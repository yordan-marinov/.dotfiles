#!/usr/bin/env bash
set -euo pipefail

STORE="${SKILLS_STORE:-${XDG_DATA_HOME:-$HOME/.local/share}/coding-factory/skills}"
AGENTS_SKILLS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
CODEX_SKILLS_DIR="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
OPENCODE_SKILLS_DIR="${OPENCODE_SKILLS_DIR:-$HOME/.config/opencode/skills}"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

[[ -f "$STORE/active" ]] || fail "no active skill release: $STORE"
release="$(cat "$STORE/active")"
source_dir="$STORE/$release"
[[ -f "$source_dir/skills/manifest.yaml" ]] || fail "active release has no skill manifest: $source_dir"

skill_names=()
while IFS= read -r name; do
  [[ -n "$name" ]] && skill_names+=("$name")
done < <(awk '/^  - name:/ {print $3}' "$source_dir/skills/manifest.yaml")
[[ "${#skill_names[@]}" -gt 0 ]] || fail "active manifest contains no skills"

sync_adapter() {
  local destination="$1"
  local metadata="$destination/.coding-factory-installed"
  local stage
  mkdir -p "$destination"

  if [[ -f "$metadata" ]]; then
    while IFS= read -r old_name; do
      [[ -n "$old_name" && -L "$destination/$old_name" ]] || continue
      case "$(readlink "$destination/$old_name")" in
        "$STORE"/*) rm "$destination/$old_name" ;;
      esac
    done < <(sed -n 's/^skill=//p' "$metadata")
  fi

  stage="$(mktemp -d "${destination%/*}/.coding-factory-adapter.XXXXXX")"
  trap 'rm -rf "$stage"' RETURN
  for name in "${skill_names[@]}"; do
    local source="$source_dir/skills/$name"
    local target="$destination/$name"
    [[ -f "$source/SKILL.md" ]] || fail "manifest skill is missing: $source/SKILL.md"
    if [[ -e "$target" && ! -L "$target" ]]; then
      fail "refusing to replace existing non-managed skill: $target"
    fi
    ln -s "$source" "$stage/$name"
  done
  for name in "${skill_names[@]}"; do
    rm -f "$destination/$name"
    mv "$stage/$name" "$destination/$name"
  done
  {
    printf 'release=%s\n' "$release"
    for name in "${skill_names[@]}"; do
      printf 'skill=%s\n' "$name"
    done
  } > "$metadata"
  printf 'installed %s adapter: %s\n' "$destination" "$release"
}

sync_adapter "$AGENTS_SKILLS_DIR"
sync_adapter "$CLAUDE_SKILLS_DIR"
sync_adapter "$CODEX_SKILLS_DIR"
sync_adapter "$OPENCODE_SKILLS_DIR"
printf 'omp adapter: %s\n' "$AGENTS_SKILLS_DIR"
printf 'codex adapter: %s\n' "$CODEX_SKILLS_DIR"
printf 'opencode adapter: %s\n' "$OPENCODE_SKILLS_DIR"
