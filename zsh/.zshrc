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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Empty line before new propt
precmd() {
    precmd() {
        echo
    }
}
plugins=(git aws python mvn)
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home"
#export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Python
alias python="python3":


# cpp compiler
function cppcompile()
{
  filename=$1
  re="^\#include \""
  while read line
  do
    if [[ $line =~ $re ]]; then
      temp=${line:9}
      temp1=${temp#\"}
      temp2=${temp1%\.*\"}
      g++ -std=c++11 -c $temp2.cpp
    fi
  done < $filename.cpp
  g++ -std=c++20 -c $filename.cpp
  g++ -o $filename *.o
  ./$filename
  rm *.o
}

# Created by `pipx` on 2024-06-20 09:32:19
export PATH="$PATH:/Users/yordan/.local/bin"
if [ -f "/Users/yordan/.config/fabric/fabric-bootstrap.inc" ]; then . "/Users/yordan/.config/fabric/fabric-bootstrap.inc"; fi

export CFLAGS="-I$(brew --prefix librdkafka)/include"
export LDFLAGS="-L$(brew --prefix librdkafka)/lib"

# Tmux
alias t=tmux

# Aliaces
alias v=nvim
alias vim=nvim
alias vi=nvim
alias c='clear'
alias pwdy="echo $(pwd) | pbcopy"
catcp() { cat $1 | pbcopy }  # For Lunux install pbcopy with xclip (apt update && apt install xclip)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Alias for .dotfiles
alias dot='cd $HOME/.dotfiles && git pull'

# Aliaces conig files
alias vdot='vim $HOME/.dotfiles'
alias vdft='vim $HOME/.dotfiles/tmux/.tmux.conf'
alias vdfv='vim $HOME/.dotfiles/vim/.vimrc'
alias vdfz='vim $HOME/.dotfiles/zsh/.zshrc'
alias vdfg='vim $HOME/.dotfiles/git/.gitconfig'
alias vdfk='vim $HOME/.dotfiles/.config/kitty/kitty.conf'
alias vdfo='vim $HOME/.dotfiles/nvim/.config/nvim/lua/plugins'

# Alias Brain-box
alias bb='vim "$HOME/Google Drive/My Drive/brain-box"'

# Alias Homelab
alias hl='cd $HOME/Dev-prjs/homelab'
alias vhl='vim "$HOME/Dev-prjs/homelab"'

# Aliaces conig files
alias vdft='vim $HOME/.dotfiles/tmux/.tmux.conf'
alias vdfv='vim $HOME/.dotfiles/vim/.vimrc'
alias vdfz='vim $home/.dotfiles/zsh/.zshrc'
alias vdfg='vim $HOME/.dotfiles/git/.gitconfig'
alias vdfk='vim $HOME/.dotfiles/kitty/kitty.conf'

## Lazygit
alias lg=lazygit

## Git
alias gits='git status'
alias gita='git add -u'
gitm() { git commit -m "$1" }
alias gitp='git push'
alias gitu='git commit -m "Update $(date +%F)"'
alias gitq='git add -u && git commit -m "Update $(date +%F)" && git push'
# alias gitc='aicommits' # requires aicommits installed (https://github.com/Nutlope/aicommits)

# --- Git Automation Functions ---

# git full: Add ALL, Commit with custom message, and Push
gf() {
  # Check if a message was provided ($1 is the first argument)
  if [ -z "$1" ]; then
    echo "❌ Error: You must provide a commit message."
    echo "Usage: gf \"your message here\""
    return 1
  fi

  echo "🚀 Starting Git Full sync..."

  # 1. Add all changes (including new files)
  git add .

  # 2. Commit with your provided message
  git commit -m "$1"

  # 3. Push to remote
  git push

  echo "✅ Done!"
}


# --- Kubernetes Aliases ---
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pods'
alias kga='kubectl get pods -A' # Get pods in All namespaces
alias kd='kubectl describe'
alias kl='kubectl logs -f'     # Follow logs
alias ke='kubectl exec -it'    # Interactive exec
alias ka='kubectl apply -f'
alias kdel='kubectl delete'
alias kctx='kubectl config use-context' # Change cluster context
alias kns='kubectl config set-context --current --namespace' # Change current namespace

# --- Talos OS Aliases ---
alias t='talosctl'
alias tn='talosctl -n' # Usage: tn 192.168.111.11 <command>
alias td='talosctl dashboard -n'

# --- ArgoCD Aliases ---
alias argologin='kubectl port-forward svc/argocd-server -n argocd 8080:443'
alias argosync='argocd app sync'

# --- Enable kubectl completion for the 'k' alias ---
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
  compdef __start_kubectl k
fi

# neofetch
neofetch
export PATH="$HOME/bin:$PATH"# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/yordan/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

eval "$(pyenv init -)"

alias libreoffice='/Applications/LibreOffice.app/Contents/MacOS/soffice'

