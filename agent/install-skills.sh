#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
LOCK_FILE="${SKILLS_LOCK_FILE:-$DOTFILES_DIR/agent/skills.lock.yaml}"
STORE="${SKILLS_STORE:-${XDG_DATA_HOME:-$HOME/.local/share}/coding-factory/skills}"

log() {
  printf '%s\n' "$1"
}

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

lock_value() {
  local key="$1"
  local value
  value="$(awk -v key="$key" '$0 ~ "^" key ":" {sub("^[^:]+:[[:space:]]*", ""); print; exit}' "$LOCK_FILE")"
  value="${value#\"}"
  value="${value%\"}"
  printf '%s' "$value"
}

[[ -f "$LOCK_FILE" ]] || fail "skill lockfile is missing: $LOCK_FILE"
command -v tar >/dev/null 2>&1 || fail "tar is required"
command -v awk >/dev/null 2>&1 || fail "awk is required"

schema_version="$(lock_value schema_version)"
profile="$(lock_value profile)"
release="$(lock_value release)"
repository="$(lock_value repository)"
artifact_name="$(lock_value artifact_name)"
artifact_url="$(lock_value artifact_url)"
expected_sha256="$(lock_value sha256)"
[[ "$schema_version" == "coding-factory-skills-lock-v1" ]] \
  || fail "unsupported skill lock schema: $schema_version"
[[ "$profile" =~ ^[A-Za-z0-9._-]+$ ]] || fail "lockfile profile is unsafe"
[[ "$release" =~ ^[A-Za-z0-9._-]+$ ]] || fail "lockfile release is unsafe"
[[ -n "$artifact_url" ]] || fail "lockfile artifact_url is missing"
[[ "$expected_sha256" =~ ^[[:xdigit:]]{64}$ ]] || fail "lockfile sha256 must be a 64-character digest"

if [[ "$artifact_url" != https://* && "$artifact_url" != file://* ]]; then
  fail "artifact_url must use https:// or file://"
fi

if command -v sha256sum >/dev/null 2>&1; then
  hash_command=(sha256sum)
elif command -v shasum >/dev/null 2>&1; then
  hash_command=(shasum -a 256)
else
  fail "sha256sum or shasum is required"
fi

PROFILE_STORE="$STORE/$profile"
mkdir -p "$PROFILE_STORE"
if [[ -f "$PROFILE_STORE/$release/.installed" ]] \
  && grep -Fxq "sha256=$expected_sha256" "$PROFILE_STORE/$release/.installed"; then
  printf 'skills already installed: %s (%s)\n' "$release" "$profile"
  printf '%s\n' "$release" > "$PROFILE_STORE/active"
  exit 0
fi

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT
archive="$work_dir/skills.tar.gz"

case "$artifact_url" in
  file://*) cp -- "${artifact_url#file://}" "$archive" ;;
  https://*)
    if [[ -n "$repository" && -n "$artifact_name" ]] && command -v gh >/dev/null 2>&1; then
      gh release download "$release" --repo "$repository" --pattern "$artifact_name" --output "$archive"
    else
      curl --fail --location --proto '=https' --tlsv1.2 --silent --show-error \
        "$artifact_url" --output "$archive"
    fi
    ;;
esac

actual_sha256="$("${hash_command[@]}" "$archive" | awk '{print $1}')"
[[ "$actual_sha256" == "$expected_sha256" ]] || fail "skill archive checksum mismatch"

stage="$work_dir/stage"
mkdir -p "$stage"
tar --extract --file="$archive" --gzip --directory="$stage"
[[ -f "$stage/GLOSSARY.md" ]] || fail "skill archive is missing GLOSSARY.md"
[[ -f "$stage/skills/manifest.yaml" ]] || fail "skill archive is missing skills/manifest.yaml"
find "$stage/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print -quit | grep -q . \
  || fail "skill archive contains no SKILL.md files"

install_dir="$PROFILE_STORE/$release"
if [[ -e "$install_dir" ]]; then
  fail "release already exists with a different digest: $install_dir"
fi
mv "$stage" "$install_dir"
printf 'profile=%s\nrelease=%s\nsha256=%s\n' \
  "$profile" "$release" "$expected_sha256" > "$install_dir/.installed"
printf '%s\n' "$release" > "$PROFILE_STORE/active"
log "installed coding-factory skills: $release"
