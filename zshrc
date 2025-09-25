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
alias zreload='source ~/.zshrc && echo "Zsh config reloaded ✅"'

# git aliases
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"

# One-shot add-all + commit
gitac() {
  git add .
  git commit -m "$*"
}

alias mkvenv="python -m venv .venv"
alias actvenv="source .venv/bin/activate"

