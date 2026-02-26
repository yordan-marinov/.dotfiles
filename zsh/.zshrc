# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="murilasso"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# --- 1. Environment Detection ---
# We use a simple check that works even if brackets are finicky
if [[ "$OSTYPE" == "darwin"* ]]; then
    IS_MAC=true
else
    IS_MAC=false
fi

# --- 2. Oh My Zsh Initialization ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

# Ensure plugins follow the OMZ standard
plugins=(git aws python mvn kubectl terraform)

# Only source OMZ if it exists physically
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# --- 3. Path & Tooling (OS Specific) ---
if [[ "$IS_MAC" == "true" ]]; then
    # macOS Specifics
    [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"
    alias libreoffice='/Applications/LibreOffice.app/Contents/MacOS/soffice'
    
    # Docker Desktop Completions
    [[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)
    
    # Mac Clipboard
    alias pwdy="echo -n \$(pwd) | pbcopy"
    catcp() { cat $1 | pbcopy }
else
    # Linux/Ubuntu Specifics
    export PATH="/usr/local/bin:$PATH"
    
    # Ubuntu Clipboard (Requires xclip)
    alias pwdy="echo -n \$(pwd) | xclip -selection clipboard"
    catcp() { cat $1 | xclip -selection clipboard }
fi

# Universal Paths
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --- 4. Brain-Box & Homelab (Stateless NAS Paths) ---
if [[ "$IS_MAC" == "true" ]]; then
    export BRAINBOX_PATH="/Volumes/brainbox/vault"
else
    export BRAINBOX_PATH="/mnt/brainbox/vault"
fi

# Aliases using the abstracted paths
alias bb="cd $BRAINBOX_PATH && nvim ."
alias hl="cd $HOME/homelab"
alias vhl="nvim $HOME/homelab"

# --- 5. General Aliases ---
alias v='nvim'
alias vim='nvim'
alias vi='nvim'
alias c='clear'
alias t='tmux'
alias lg='lazygit'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# --- 6. GitOps & Git Automation ---
alias gits='git status'
alias gita='git add .'
alias gitp='git push'
alias gitq='git add . && git commit -m "Update $(date +%F)" && git push'

# The "Git Full" Function (gf "message")
# We unalias first to prevent the 'defining function based on alias' error
unalias gf 2>/dev/null
gf() {
  if [ -z "$1" ]; then
    echo "❌ Error: Provide a commit message: gf \"message\""
    return 1
  fi
  git add . && git commit -m "$1" && git push
}

# --- 7. Kubernetes & Cluster Management ---
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kga='kubectl get pods -A'
alias kd='kubectl describe'
alias kl='kubectl logs -f'
alias ke='kubectl exec -it'
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kns='kubectl config set-context --current --namespace'

# Talos & Argo
alias t='talosctl'
alias tn='talosctl -n'
alias td='talosctl dashboard -n'
alias argologin='kubectl port-forward svc/argocd-server -n argocd 8080:443'

# --- 8. Dotfiles Management ---
alias dot="cd $HOME/.dotfiles && git pull && stow zsh tmux nvim"
alias vdfz="nvim $HOME/.dotfiles/zsh/.zshrc"
alias vdft="nvim $HOME/.dotfiles/tmux/.tmux.conf"
alias vdfg="nvim $HOME/.dotfiles/git/.gitconfig"
alias vdfo="nvim $HOME/.dotfiles/nvim/.config/nvim/lua/plugins"

# --- 9. Final Initializations ---
# Load local secrets (Omni tokens, etc)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load FZF if exists
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Load Pyenv
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi

# Visuals
if command -v neofetch &> /dev/null; then
    neofetch
fi

# Empty line before new prompt
precmd() { echo "" }
