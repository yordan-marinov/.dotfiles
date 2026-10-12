# Dotfiles

A curated set of personal Linux and terminal configuration files used to support development, automation, and day-to-day platform work.

This repository is not meant to be a product on its own; it exists as a lightweight showcase of how I keep my working environment reproducible and efficient across machines.

## What this repository demonstrates
- Linux-focused development workflow
- reproducible shell and terminal setup
- simple machine bootstrap habits
- separation of shared config from local secrets
- practical tooling for engineering productivity

## Included configuration areas
- `zsh/` — shell configuration
- `tmux/` — terminal multiplexer setup
- `git/` — Git configuration
- `nvim/` — Neovim (LazyVim) set up as an IDE; see [Neovim](#neovim)
- `bin/` — small helper scripts
- `bootstrap.sh` — machine setup helper

## Neovim
`vim`, `vi` and `v` all run `nvim`. LazyVim, plus language support for Python, shell, Markdown, YAML (GitLab CI schema included), Terraform/OpenTofu, Docker, SQL, TOML, JSON and Jinja templates (`*.sql.j2` / `*.yaml.j2` highlight as the language they render to), with debugging (`nvim-dap`) and a test runner (`neotest`).

- Plugins are pinned in `nvim/.config/nvim/lazy-lock.json`. `:Lazy update` moves them; commit the lockfile so every machine follows.
- `bootstrap.sh` runs `nvim --headless "+Lazy! restore" +IdeSync +qa`: plugins at the locked versions, then every LSP server, linter, formatter, debug adapter and treesitter parser, installed up front. Run `:IdeSync` again after adding a language.
- Python resolves through the project's `.venv` (`uv sync`): pyright analyses against its interpreter, and ruff runs at the project's pinned version and `line-length`.
- Format on save is on for Python (ruff) and Terraform (`tofu fmt`), off for Markdown, YAML and shell, where it would rewrite lines you didn't touch; `<leader>cf` formats on demand.
- A repo whose `.tflint.hcl` declares plugins needs `tflint --init` once, or the tflint language server exits on start.

## Approach
The repo uses GNU Stow-style organization so configuration can be linked into a home directory in a simple and maintainable way. If GNU Stow is not installed yet, `scripts/apply-dotfiles.py` provides a built-in symlink fallback.

## Tooling expectations
The shared shell/bootstrap is intended to work across:
- personal Linux machines
- remote Linux workspaces
- macOS laptops, including Apple Silicon via Homebrew under `/opt/homebrew`

It keeps the same command surface where practical, including existing aliases, and bootstraps terminal-first agent tooling via `omp` / oh-my-pi plus `herdr` for terminal agent/session orchestration.

Notable shared shortcuts include:
- `t` → `tmux`
- `h` → `herdr`
- `p`, `pi` → `omp`
- `tal` → `talosctl`

## Local setup example
```bash
git clone git@github.com:yordan-marinov/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

On a new Mac, install Homebrew first, then run the bootstrap. Machine-only paths and secrets belong in `~/.zshrc.local`; Git identity belongs in `~/.gitconfig.local` so personal and work laptops do not share the same name/email.

## Agent tooling
Bootstrap installs `omp` using the official installer:

```bash
curl -fsSL https://omp.sh/install | sh
```

It also installs `herdr` with Homebrew, or with the official installer where Homebrew is not available:

```bash
brew install herdr
# or
curl -fsSL https://herdr.dev/install.sh | sh
```

## Security note
Machine-specific secrets should stay outside the repository in local-only files such as `~/.zshrc.local`.

## Why keep this public
Although this is a personal configuration repo, it also reflects engineering discipline around reproducibility, tooling, and secure separation of shared configuration from sensitive local state.
