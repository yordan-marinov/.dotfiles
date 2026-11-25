# Company skill profile approval

## Scope

The v0.1.5 company archive contains only:

- `teach`
- `domain-modeling`
- `strategy-router`
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
release=v0.1.5
archive_sha256=ae56c73ce3fd248b57716e031e0c555c6994f3b481ce27e7a71650da8b18fad0
verification=passed
```

Never record tokens, cookies, private keys, or authorization headers.
