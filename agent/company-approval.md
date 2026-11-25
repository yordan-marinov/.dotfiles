# Company skill profile approval

## Scope

The v0.1.11 company archive contains only:

- `teach`
- `merge-danger`
- `automated-code-review`
- `domain-modeling`
- `strategy-router`
- `repository-consistency`
- the shared glossary, filtered manifest, and harness adapter instructions

It excludes personal Git identity, homelab, OIDC, and Agent Platform operational skills.

## Required approval

The profile is content-safe but is not a substitute for company policy approval. Before enabling it on a company-managed machine, obtain approval for:

1. reading the private `mvg-labs/coding-factory` release asset;
2. using the selected company GitHub identity or GitHub App in read-only mode;
3. installing Markdown skill instructions into the approved harness directories;
4. storing the verified archive under the user's local data directory.

Use a company-approved GitHub App, machine account, or ephemeral `GH_TOKEN`. Do not use a personal human GitHub token, persist credentials in dotfiles, or copy credentials into the lockfile.

## Installation

Clone or update the dotfiles repository using the company's approved read-only access path, then run only the company bootstrap. Do not run the personal `bootstrap.sh` on a company-managed machine unless its shell/editor/Git changes have separately been approved.

```bash
cd ~/.dotfiles
git pull --ff-only origin main
./agent/bootstrap-company.sh
```

`install-skills.sh` uses `gh release download` for this private profile and fails closed when the GitHub CLI credential helper is unavailable. The lockfile verifies the release, commit, asset name, URL, and SHA-256 digest.

## Evidence

Record only:

```text
profile=company
release=v0.1.11
archive_sha256=78cf109653ba7e9f316df1989e299965c5fa1f07c8d64e2710da7a8d5c75d344
verification=passed
```

Never record tokens, cookies, private keys, or authorization headers.
