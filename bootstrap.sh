#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-git@github.com:yordan-marinov/.dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
BACKUP_SUFFIX="$(date +%Y%m%d-%H%M%S)"

log() {
  printf '%s\n' "$1"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

path_is_symlink_to() {
  local path="$1"
  local expected_prefix="$2"
  [[ -L "$path" ]] || return 1
  local resolved
  resolved="$(python3 - "$path" <<'PY'
import os, sys
print(os.path.realpath(sys.argv[1]))
PY
)"
  [[ "$resolved" == "$expected_prefix"* ]]
}

backup_if_conflicting() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || return 0
  if path_is_symlink_to "$path" "$DOTFILES_DIR/"; then
    return 0
  fi
  local backup_path="${path}.pre-dotfiles-${BACKUP_SUFFIX}"
  log "📦 Backing up $path -> $backup_path"
  mv "$path" "$backup_path"
}

install_linux_packages() {
  log '📦 Installing Linux dependencies...'
  sudo apt update
  sudo apt install -y \
    build-essential cargo cifs-utils curl fd-find fontconfig git neovim \
    python3-pip python3-venv ripgrep stow tmux unzip xclip zsh
}

install_mac_packages() {
  if ! command_exists brew; then
    log '❌ Homebrew is required on macOS. Install Homebrew first: https://brew.sh'
    exit 1
  fi

  log '📦 Installing macOS dependencies...'
  brew install git stow curl zsh tmux neovim ripgrep fd fzf lazygit rust
  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  brew install --cask kitty font-jetbrains-mono-nerd-font
}

install_oh_my_zsh() {
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log '🐚 Installing Oh My Zsh...'
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  local custom_plugins="$HOME/.oh-my-zsh/custom/plugins"
  mkdir -p "$custom_plugins"
  if [[ ! -d "$custom_plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins/zsh-autosuggestions"
  fi
  if [[ ! -d "$custom_plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins/zsh-syntax-highlighting"
  fi
}

install_omp() {
  if command_exists omp; then
    return 0
  fi

  log '🤖 Installing omp / oh-my-pi...'
  curl -fsSL https://omp.sh/install | sh
}

install_herdr() {
  if command_exists herdr; then
    return 0
  fi

  if ! command_exists cargo; then
    log '⚠️ cargo is not available; skipping herdr install.'
    return 0
  fi

  log '🐑 Installing herdr via cargo...'
  cargo install herdr
}

stow_modules() {
  local modules=(zsh tmux git nvim kitty bin)
  if [[ "$OSTYPE" != darwin* ]] && [[ -d "$DOTFILES_DIR/toshy" ]]; then
    modules+=(toshy)
  fi

  log '🔗 Linking configurations...'
  cd "$DOTFILES_DIR"
  for module in "${modules[@]}"; do
    if [[ -d "$module" ]]; then
      log "   -> Stowing $module"
      stow -R -t "$HOME" "$module"
    fi
  done
}

prepare_conflicts() {
  backup_if_conflicting "$HOME/.zshrc"
  backup_if_conflicting "$HOME/.tmux.conf"
  backup_if_conflicting "$HOME/.gitconfig"
  backup_if_conflicting "$HOME/.gitignore_global"
  backup_if_conflicting "$HOME/.config/nvim"
  backup_if_conflicting "$HOME/.config/kitty"
}

create_linux_mount_points() {
  [[ "$OSTYPE" == darwin* ]] && return 0
  log '📂 Creating Linux mount points...'
  sudo mkdir -p /mnt/brainbox /mnt/wbridge
  sudo chown -R "$USER":"$USER" /mnt/brainbox /mnt/wbridge
}

create_local_override() {
  if [[ -f "$HOME/.gitconfig.local" ]]; then
    :
  else
    log '🔐 Creating git local override placeholder...'
    cat <<'EOF' > "$HOME/.gitconfig.local"
# Machine-specific Git identity overrides, if needed.
# [user]
#   email = you@example.com
EOF
  fi

  if [[ -f "$HOME/.zshrc.local" ]]; then
    return 0
  fi

  log '🔐 Creating shell local override placeholder...'
  cat <<'EOF' > "$HOME/.zshrc.local"
# Machine-specific overrides
# Linux default: /mnt/brainbox/vault
# macOS default: /Volumes/brainbox/vault
# export BRAINBOX_PATH="/Volumes/brainbox/vault"
EOF
}

ensure_repo() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    return 0
  fi

  log '📂 Cloning dotfiles repository...'
  git clone "$REPO_URL" "$DOTFILES_DIR"
}

main() {
  log '🧱 Starting dotfiles bootstrap...'

  case "$OSTYPE" in
    darwin*) install_mac_packages ;;
    linux-gnu*|linux*) install_linux_packages ;;
    *)
      log "❌ Unsupported platform: $OSTYPE"
      exit 1
      ;;
  esac

  ensure_repo
  install_oh_my_zsh
  prepare_conflicts
  create_linux_mount_points
  stow_modules
  install_omp
  install_herdr
  create_local_override

  chmod +x "$DOTFILES_DIR/bin/"* || true

  if command_exists zsh && [[ "$SHELL" != "$(command -v zsh)" ]]; then
    log '🔄 Changing default shell to zsh...'
    chsh -s "$(command -v zsh)"
  fi

  log '✅ DONE! Restart your shell, then run omp when needed.'
}

main "$@"
