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

# Find Git repos under the given directory and show uncommitted changes.
gst() {
  local base_dir="${1:-.}"
  local git_marker repo status_output

  while IFS= read -r -d '' git_marker; do
    repo="${git_marker%/.git}"

    if status_output=$(git -C "$repo" status --short 2>&1); then
      if [[ -n "$status_output" ]]; then
        printf '\n🔹 Repo: %s\n%s\n' "$repo" "$status_output"
      fi
    else
      printf '\n⚠️ Repo: %s\n%s\n' "$repo" "$status_output" >&2
    fi
  done < <(
    find "$base_dir" -name .git \( -type d -o -type f \) -print0 -prune
  )
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
