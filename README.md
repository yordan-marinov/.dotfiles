# 🚀 Enterprise-Grade Dotfiles

My personal environment configurations managed with **GNU Stow**. Designed for high-speed infrastructure management, Kubernetes operations, and consistent terminal workflows across macOS and Ubuntu.

## 📦 What's Inside?
- **Shell:** `zsh` + `Oh My Zsh` (Agnoster/P10k)
- **Editor:** `nvim` (LazyVim/Custom)
- **Multiplexer:** `tmux`
- **Terminal:** `kitty`
- **Identity:** `git`
- **Tools:** `bin` (Custom scripts)

---

## 🛠️ Bootstrapping a New Machine

To deploy this environment on a fresh Ubuntu/Debian server, follow these three steps:

### Run the Bootstrap Script

Copy and run this command to download the installer and begin the link process:

```
# Clone the repo (Switch to your SSH URL after adding keys)
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles

# Run the installer
cd ~/.dotfiles
chmod +x bootstrap.sh
./bootstrap.sh
```
### Add Local Secrets

The environment looks for a ~/.zshrc.local file for machine-specific keys (like Omni tokens) that are never committed to Git.

```
nano ~/.zshrc.local
# Paste exports here:
# export ACCOUNT_KEY="..."
```
