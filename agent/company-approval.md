# Company skill profile approval

## Scope

The company profile is a conservative distribution of the Coding Factory library. The v0.1.3 company archive contains only:

- `teach`
- `domain-modeling`
- `strategy-router`
- the shared glossary and filtered manifest

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
release=v0.1.3
archive_sha256=da98257085371e8b134d847e52f99c916167804076117d43a1093db46f2ac8de
verification=passed
```

Never record tokens, cookies, private keys, or authorization headers.
