# path to OhMyZsh
export ZSH="$HOME/.oh-my-zsh"

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

# kicad environment variables
export THONK_LIB_DIR="$HOME/Documents/thonk/thonk-kicad-lib"
export THONK_3D_MODELS="$THONK_LIB_DIR/3d"

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# zsh autosuggestions color (more visible)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888'

# --------------------
# aliases
# --------------------
alias ll="ls -lh"
alias la="ls -lha"

alias zedit="nano ~/.zshrc"
alias zrl='source ~/.zshrc && echo "Zsh config reloaded ✅"'

unalias gst 2>/dev/null

gst() {
  local dir
  local base_dir="${1:-.}" # default to current directory if none passed

  find "$base_dir" -type d -name ".git" | while read -r dir; do
    repo_dir="$(dirname "$dir")"
    echo "🔹 Repo: $repo_dir"
    git -C "$repo_dir" status -s
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


alias mkvenv="python -m venv .venv"
alias actvenv="source .venv/bin/activate"

alias bu='brew update && brew upgrade && brew upgrade --cask && brew cleanup'

export PATH="/opt/homebrew/bin:$PATH"
