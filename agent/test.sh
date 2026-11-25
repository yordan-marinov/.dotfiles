#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

make_archive() {
  local profile="$1"
  local output="$2"
  local stage="$WORK_DIR/$profile"
  mkdir -p "$stage/skills/teach" "$stage/skills/domain-modeling" "$stage/adapters"
  printf '# Glossary\n' > "$stage/GLOSSARY.md"
  printf '# Teach\n' > "$stage/skills/teach/SKILL.md"
  printf '# Domain Modeling\n' > "$stage/skills/domain-modeling/SKILL.md"
  printf 'schema_version: coding-factory-harness-adapters-v1\nrouter_command: coding-factory strategy-route\n' \
    > "$stage/adapters/manifest.yaml"
  local entries="- name: teach\n  path: skills/teach/SKILL.md\n  invocation: user\n- name: domain-modeling\n  path: skills/domain-modeling/SKILL.md\n  invocation: model\n"
  if [[ "$profile" == personal ]]; then
    mkdir -p "$stage/skills/private-skill"
    printf '# Private Skill\n' > "$stage/skills/private-skill/SKILL.md"
    entries+="- name: private-skill\n  path: skills/private-skill/SKILL.md\n  invocation: user\n"
  fi
  {
    printf 'schema_version: coding-factory-skills-v1\nlibrary: coding-factory\nskills:\n'
    printf '%b' "$entries" | sed 's/^/  /'
    printf 'profiles:\n  %s:\n    - teach\n    - domain-modeling\n' "$profile"
    if [[ "$profile" == personal ]]; then
      printf '    - private-skill\n'
    fi
  } > "$stage/skills/manifest.yaml"
  tar -czf "$output" -C "$stage" .
}

write_lock() {
  local profile="$1"
  local archive="$2"
  local lock="$3"
  local digest
  digest="$(sha256sum "$archive" | awk '{print $1}')"
  printf 'schema_version: coding-factory-skills-lock-v1\nprofile: %s\nrelease: test-%s\nartifact_url: file://%s\nsha256: %s\n' \
    "$profile" "$profile" "$archive" "$digest" > "$lock"
}

make_archive personal "$WORK_DIR/personal.tar.gz"
make_archive company "$WORK_DIR/company.tar.gz"
write_lock personal "$WORK_DIR/personal.tar.gz" "$WORK_DIR/personal.lock.yaml"
write_lock company "$WORK_DIR/company.tar.gz" "$WORK_DIR/company.lock.yaml"

HOME="$WORK_DIR/personal-home" \
  SKILLS_PROFILE=personal \
  SKILLS_LOCK_FILE="$WORK_DIR/personal.lock.yaml" \
  SKILLS_STORE="$WORK_DIR/store" \
  "$SCRIPT_DIR/install-skills.sh"
HOME="$WORK_DIR/personal-home" SKILLS_PROFILE=personal SKILLS_STORE="$WORK_DIR/store" "$SCRIPT_DIR/install-adapters.sh"
HOME="$WORK_DIR/personal-home" SKILLS_PROFILE=personal SKILLS_STORE="$WORK_DIR/store" "$SCRIPT_DIR/verify-skills.sh"
HOME="$WORK_DIR/personal-home" SKILLS_PROFILE=personal SKILLS_STORE="$WORK_DIR/store" \
  SKILLS_LOCK_FILE="$WORK_DIR/personal.lock.yaml" "$SCRIPT_DIR/doctor.sh"
HOME="$WORK_DIR/personal-home" \
  SKILLS_PROFILE=personal \
  SKILLS_LOCK_FILE="$WORK_DIR/personal.lock.yaml" \
  SKILLS_STORE="$WORK_DIR/store" \
  "$SCRIPT_DIR/install-skills.sh"

HOME="$WORK_DIR/company-home" \
  SKILLS_PROFILE=company \
  SKILLS_LOCK_FILE="$WORK_DIR/company.lock.yaml" \
  SKILLS_STORE="$WORK_DIR/store" \
  "$SCRIPT_DIR/install-skills.sh"
HOME="$WORK_DIR/company-home" SKILLS_PROFILE=company SKILLS_STORE="$WORK_DIR/store" "$SCRIPT_DIR/install-adapters.sh"
HOME="$WORK_DIR/company-home" SKILLS_PROFILE=company SKILLS_STORE="$WORK_DIR/store" "$SCRIPT_DIR/verify-skills.sh"
HOME="$WORK_DIR/company-home" SKILLS_PROFILE=company SKILLS_STORE="$WORK_DIR/store" \
  SKILLS_LOCK_FILE="$WORK_DIR/company.lock.yaml" "$SCRIPT_DIR/doctor.sh"
[[ ! -e "$WORK_DIR/company-home/.agents/skills/private-skill" ]]

mkdir -p "$WORK_DIR/conflict-home/.agents/skills"
printf 'unmanaged\n' > "$WORK_DIR/conflict-home/.agents/skills/teach"
if HOME="$WORK_DIR/conflict-home" SKILLS_PROFILE=company SKILLS_STORE="$WORK_DIR/store" "$SCRIPT_DIR/install-adapters.sh"; then
  printf 'ERROR: unmanaged adapter conflict was not rejected\n' >&2
  exit 1
fi

printf 'dotfiles agent environment checks passed\n'
