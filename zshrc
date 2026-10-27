# path to OhMyZsh
export ZSH="$HOME/.oh-my-zsh"

# Drop stale pyenv paths if they leak in from a parent shell.
typeset -U path PATH
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})
path=($HOME/.local/bin /opt/homebrew/bin /Applications/KiCad/KiCad.app/Contents/Applications/gerbview.app/Contents/MacOS $path)

# theme
ZSH_THEME=""

# plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
# Pure prompt
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -U promptinit
promptinit
prompt pure

# --------------------
# custom env vars
# --------------------

# zsh autosuggestions color (more visible)
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#888888'

# --------------------
# aliases
# --------------------
alias ll="ls -lh"
alias la="ls -lha"

alias zedit="nano ~/.zshrc"
alias zrl='source ~/.zshrc && echo "Zsh config reloaded"'


# git aliases
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gs="git status"


unalias mkvenv 2>/dev/null
mkvenv() {
  uv venv --python 3.14 --seed --prompt "${1:-py}" && source .venv/bin/activate
}

alias actvenv="source .venv/bin/activate"

alias bu='brew upgrade'

alias cgerb="~/.cgerb.sh"

alias ss="python3 ~/.screenshot.py"

#rust
source "$HOME/.cargo/env"
