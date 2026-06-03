# path to OhMyZsh
export ZSH="$HOME/.oh-my-zsh"

# Drop stale pyenv paths if they leak in from a parent shell.
typeset -U path PATH
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})
path=($HOME/.local/bin /opt/homebrew/bin /Applications/KiCad/KiCad.app/Contents/Applications/gerbview.app/Contents/MacOS $path)

# theme
ZSH_THEME="robbyrussell"

# plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# --------------------
# custom env vars
# --------------------

# zsh autosuggestions color (more visible)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888'

# --------------------
# aliases
# --------------------
alias ll="ls -lh"
alias la="ls -lha"

alias zedit="nano ~/.zshrc"
alias zrl='source ~/.zshrc && echo "Zsh config reloaded"'

unalias gst 2>/dev/null

# search current diretory and subdirectories for git repos and show their status
gst() {
  local base_dir="${1:-.}"
  local current_git_root
  local current_dir

  current_git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  current_dir=$(pwd)

  if [[ -z "$current_git_root" ]]; then
    echo "Not in a git repository"
    return
  fi

  # If we're not at the root, only show files from current dir
  if [[ "$current_dir" != "$current_git_root" ]]; then
    echo "🔹 Repo: $current_dir"
    git status -s -- "$current_dir"
  else
    # At root, show all changes
    echo "🔹 Repo: $current_git_root"
    git status -s
  fi
}

# pull latest for all git repos in current directory and subdirectories
gpull() {
  local dir
  local base_dir="${1:-.}"

  find "$base_dir" -type d -name ".git" | while read -r dir; do
    repo_dir="$(dirname "$dir")"
    echo "🔹 Repo: $repo_dir"
    git -C "$repo_dir" pull
    echo
  done
}

# git aliases
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gs="git status"

# One-shot add-all + commit
gac() {
  git add .
  git commit -m "$*"
  git push
}


unalias mkvenv 2>/dev/null
mkvenv() {
  uv venv --python 3.14 --seed --prompt "${1:-py}" && source .venv/bin/activate
}

alias actvenv="source .venv/bin/activate"

alias bu='brew update && brew upgrade && brew upgrade --cask && brew cleanup'

alias cgerb="~/.cgerb.sh"

alias ss="python3 ~/.screenshot.py"

#rust
source "$HOME/.cargo/env"
