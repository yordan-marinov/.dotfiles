#!/usr/bin/env bash
set -euo pipefail

STORE="${SKILLS_STORE:-${XDG_DATA_HOME:-$HOME/.local/share}/coding-factory/skills}"
[[ -f "$STORE/active" ]] || { printf 'ERROR: no active skill release: %s\n' "$STORE" >&2; exit 1; }
release="$(cat "$STORE/active")"
install_dir="$STORE/$release"
[[ -f "$install_dir/.installed" ]] || { printf 'ERROR: installed marker is missing: %s\n' "$install_dir" >&2; exit 1; }
[[ -f "$install_dir/GLOSSARY.md" ]] || { printf 'ERROR: GLOSSARY.md is missing\n' >&2; exit 1; }
[[ -f "$install_dir/skills/manifest.yaml" ]] || { printf 'ERROR: skill manifest is missing\n' >&2; exit 1; }
find "$install_dir/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print -quit | grep -q . \
  || { printf 'ERROR: no installed skills found\n' >&2; exit 1; }

printf 'valid coding-factory skills: %s\n' "$release"
cat "$install_dir/.installed"
