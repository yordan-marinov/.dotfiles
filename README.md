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

## Tooling expectations
The shared shell/bootstrap is intended to work across:
- personal Linux machines
- remote Linux workspaces
- macOS laptops

It keeps the same command surface where practical, including existing aliases, and bootstraps terminal-first agent tools such as:
- `pi`
- `herdr`
- the local `pi-honcho` package for honcho adapter access

Notable shared shortcuts include:
- `t` → `tmux`
- `h` → `herdr`
- `tal` → `talosctl`
- `dopi` → open `pi` in `${HONCHO_EXECUTION_PLANE_REPO:-~/platform/execution-plane}`
- `vep` / `vhpi` → open the honcho execution-plane repo in `nvim`

## Local setup example
```bash
git clone git@github.com:yordan-marinov/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

## Pi honcho integration
The dotfiles repo now carries a local Pi package at `pi-honcho/`.

Bootstrap registers that package in `~/.pi/agent/settings.json`, so each trusted local Pi instance can load the honcho adapter extension automatically.

The extension adds:
- `honcho_dispatch` tool — runs `scripts/interfaces/run-from-pi.sh`
- `/honcho <request>` — manual command wrapper for the same adapter
- `dopi` — shell shortcut that opens `pi` from the execution-plane checkout
- env overrides via `HONCHO_EXECUTION_PLANE_REPO` and `HONCHO_PROFILE_FILE`

## Security note
Machine-specific secrets should stay outside the repository in local-only files such as `~/.zshrc.local`.

## Why keep this public
Although this is a personal configuration repo, it also reflects engineering discipline around reproducibility, tooling, and secure separation of shared configuration from sensitive local state.
