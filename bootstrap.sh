#!/usr/bin/env bash
set -e

# --- Configuration ---
# You can change these if you ever move your repo
REPO_URL="https://github.com/your-username/your-dotfiles-repo.git"
DOTFILES_DIR="$HOME/.dotfiles"

echo "🧱 Starting Fresh Machine Bootstrap..."

# 1. Install System Prerequisites
echo "📦 Installing Git, Stow, Curl, and Zsh..."
sudo apt update
sudo apt install -y git stow curl zsh tmux neovim build-essential

# 2. Clone the repo if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📂 Cloning dotfiles repository..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# 3. Install Oh My Zsh (Unattended)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 4. Clean up default Ubuntu files that conflict with Stow
# On a fresh install, Ubuntu creates .bashrc and .profile by default
echo "🧹 Removing default config files to prevent Stow conflicts..."
rm -f "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile" "$HOME/.bash_logout"

# 5. Run GNU Stow
echo "🔗 Linking configurations..."
cd "$DOTFILES_DIR"

# List your specific folders in the repo
modules=(zsh tmux git nvim kitty bin)

for module in "${modules[@]}"; do
    if [ -d "$module" ]; then
        echo "   -> Stowing $module"
        # We run stow from inside the dotfiles folder to ensure relative links
        stow -R -t "$HOME" "$module"
    fi
done

# 6. Create local secrets placeholder
if [ ! -f "$HOME/.zshrc.local" ]; then
    echo "🔐 Creating local secrets placeholder..."
    cat <<EOF > "$HOME/.zshrc.local"
# Machine-specific overrides
# export OMNI_ENDPOINT="..."
# export OMNI_SERVICE_ACCOUNT_KEY="..."
EOF
fi

# 7. Finalize: Change Shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔄 Changing default shell to Zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
fi

echo "✅ DONE! Log out and back in to enter your new environment."
