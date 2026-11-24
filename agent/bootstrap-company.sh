#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd -- "$SCRIPT_DIR/.." && pwd)}"
LOCK_FILE="${SKILLS_LOCK_FILE:-$DOTFILES_DIR/agent/skills.lock.company.yaml}"
STORE="${SKILLS_STORE:-${XDG_DATA_HOME:-$HOME/.local/share}/coding-factory/skills}"

[[ -f "$LOCK_FILE" ]] || {
  printf 'ERROR: company skill lockfile is missing: %s\n' "$LOCK_FILE" >&2
  exit 1
}

SKILLS_PROFILE=company SKILLS_LOCK_FILE="$LOCK_FILE" SKILLS_STORE="$STORE" \
  "$DOTFILES_DIR/agent/install-skills.sh"
SKILLS_PROFILE=company SKILLS_STORE="$STORE" \
  "$DOTFILES_DIR/agent/install-adapters.sh"
SKILLS_PROFILE=company SKILLS_STORE="$STORE" \
  "$DOTFILES_DIR/agent/verify-skills.sh"
SKILLS_PROFILE=company SKILLS_STORE="$STORE" SKILLS_LOCK_FILE="$LOCK_FILE" \
  "$DOTFILES_DIR/agent/doctor.sh"
