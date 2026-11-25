#!/usr/bin/env bash
# shellcheck disable=SC2015

STORE="${SKILLS_STORE:-${XDG_DATA_HOME:-$HOME/.local/share}/coding-factory/skills}"
PROFILE="${SKILLS_PROFILE:-personal}"
LOCK_FILE="${SKILLS_LOCK_FILE:-$HOME/.dotfiles/agent/skills.lock.yaml}"
AGENTS_SKILLS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
OPENCODE_SKILLS_DIR="${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}"

errors=0

lock_value() {
  local key="$1"
  local value
  value="$(awk -v key="$key" '$0 ~ "^" key ":" {sub("^[^:]+:[[:space:]]*", ""); print; exit}' "$LOCK_FILE")"
  value="${value#\"}"
  value="${value%\"}"
  printf '%s' "$value"
}

pass_check() {
  printf 'check=%s status=pass\n' "$1"
}

fail_check() {
  printf 'check=%s status=fail detail=%s\n' "$1" "$2"
  errors=$((errors + 1))
}

if [[ ! -f "$LOCK_FILE" ]]; then
  printf 'status=fail\ndetail=missing lockfile:%s\n' "$LOCK_FILE"
  exit 1
fi

schema_version="$(lock_value schema_version)"
lock_profile="$(lock_value profile)"
release="$(lock_value release)"
commit="$(lock_value commit)"
expected_sha256="$(lock_value sha256)"

[[ "$schema_version" == "coding-factory-skills-lock-v1" ]] \
  && pass_check lock_schema \
  || fail_check lock_schema "unsupported:$schema_version"
[[ "$lock_profile" == "$PROFILE" ]] \
  && pass_check lock_profile \
  || fail_check lock_profile "expected:$PROFILE actual:$lock_profile"
[[ -n "$release" ]] \
  && pass_check lock_release \
  || fail_check lock_release missing
[[ "$expected_sha256" =~ ^[[:xdigit:]]{64}$ ]] \
  && pass_check lock_digest \
  || fail_check lock_digest invalid

profile_store="$STORE/$PROFILE"
if [[ -f "$profile_store/active" ]]; then
  active_release="$(cat "$profile_store/active")"
  [[ "$active_release" == "$release" ]] \
    && pass_check active_release \
    || fail_check active_release "expected:$release actual:$active_release"
else
  fail_check active_release "missing:$profile_store/active"
  active_release="$release"
fi

install_dir="$profile_store/$active_release"
[[ -d "$install_dir" ]] \
  && pass_check install_directory \
  || fail_check install_directory "missing:$install_dir"

if [[ -f "$install_dir/.installed" ]]; then
  grep -Fxq "profile=$PROFILE" "$install_dir/.installed" \
    && pass_check installed_profile \
    || fail_check installed_profile mismatch
  grep -Fxq "release=$release" "$install_dir/.installed" \
    && pass_check installed_release \
    || fail_check installed_release mismatch
  grep -Fxq "sha256=$expected_sha256" "$install_dir/.installed" \
    && pass_check installed_digest \
    || fail_check installed_digest mismatch
else
  fail_check installed_marker "missing:$install_dir/.installed"
fi

manifest="$install_dir/skills/manifest.yaml"
if [[ -f "$manifest" ]]; then
  pass_check manifest
else
  fail_check manifest "missing:$manifest"
fi
adapter_manifest="$install_dir/adapters/manifest.yaml"
if [[ -f "$adapter_manifest" ]]; then
  grep -Fxq 'router_command: coding-factory strategy-route' "$adapter_manifest" \
    && pass_check adapter_manifest \
    || fail_check adapter_manifest incompatible
else
  fail_check adapter_manifest "missing:$adapter_manifest"
fi

skill_names=()
if [[ -f "$manifest" ]]; then
  while IFS= read -r name; do
    [[ -n "$name" ]] && skill_names+=("$name")
  done < <(awk '/^[[:space:]]*-[[:space:]]+name:/ {print $3}' "$manifest")
fi
[[ "${#skill_names[@]}" -gt 0 ]] \
  && pass_check skill_manifest_entries \
  || fail_check skill_manifest_entries empty

for adapter in \
  "agents:$AGENTS_SKILLS_DIR" \
  "claude:$CLAUDE_SKILLS_DIR" \
  "codex:$CODEX_SKILLS_DIR" \
  "opencode:$OPENCODE_SKILLS_DIR"; do
  adapter_name="${adapter%%:*}"
  adapter_dir="${adapter#*:}"
  metadata="$adapter_dir/.coding-factory-installed"
  if [[ ! -f "$metadata" ]]; then
    fail_check "adapter_${adapter_name}_metadata" "missing:$metadata"
    continue
  fi
  grep -Fxq "release=$release" "$metadata" \
    && pass_check "adapter_${adapter_name}_release" \
    || fail_check "adapter_${adapter_name}_release" mismatch
  for name in "${skill_names[@]}"; do
    target="$adapter_dir/$name"
    expected="$install_dir/skills/$name"
    if [[ -L "$target" && "$(readlink "$target")" == "$expected" ]]; then
      pass_check "adapter_${adapter_name}_$name"
    else
      fail_check "adapter_${adapter_name}_$name" "expected_symlink:$expected"
    fi
  done
  while IFS= read -r old_name; do
    [[ -n "$old_name" ]] || continue
    if ! printf '%s\n' "${skill_names[@]}" | grep -Fxq "$old_name"; then
      fail_check "adapter_${adapter_name}_stale_$old_name" stale
    fi
  done < <(sed -n 's/^skill=//p' "$metadata")
done

printf 'profile=%s\nrelease=%s\ncommit=%s\narchive_sha256=%s\n' \
  "$PROFILE" "$release" "$commit" "$expected_sha256"
if [[ "$errors" -eq 0 ]]; then
  printf 'status=pass\n'
else
  printf 'status=fail\nerrors=%s\n' "$errors"
fi
exit "$errors"
