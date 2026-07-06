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
- `bin/` — small helper scripts
- `bootstrap.sh` — machine setup helper

## Approach
The repo uses GNU Stow-style organization so configuration can be linked into a home directory in a simple and maintainable way.

## Local setup example
```bash
git clone git@github.com:yordan-marinov/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

## Security note
Machine-specific secrets should stay outside the repository in local-only files such as `~/.zshrc.local`.

## Why keep this public
Although this is a personal configuration repo, it also reflects engineering discipline around reproducibility, tooling, and secure separation of shared configuration from sensitive local state.
