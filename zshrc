# Paths -----------------------------------------------------------------------
# Keep PATH entries unique and remove stale pyenv paths inherited from a parent.
typeset -U path PATH
path=(${path:#$HOME/.pyenv/shims})
path=(${path:#$HOME/.pyenv/bin})
path=(
  "$HOME/.local/bin"
  /opt/homebrew/bin
  /Applications/KiCad/KiCad.app/Contents/Applications/gerbview.app/Contents/MacOS
  $path
)

# Oh My Zsh -------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # The separate Fade configuration handles the prompt.
plugins=(
  git
  copypath
  copyfile
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source "$ZSH/oh-my-zsh.sh"

# Completion and prompt -------------------------------------------------------
zstyle ':completion:*' menu select
source "$HOME/.config/zsh/fade.zsh"

# Files and shell configuration ------------------------------------------------
alias ll='ls -lh'
alias la='ls -lha'
alias zedit='micro ~/.zshrc'
alias zrl='source ~/.zshrc && echo "Zsh config reloaded"'

# Git -------------------------------------------------------------------------
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gs='git status --short'

# Jump to the top of the current Git project.
root() {
  local project_root
  project_root=$(command git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 'Not inside a Git project.'
    return 1
  }
  builtin cd -- "$project_root"
}

unalias grh 2>/dev/null

grh() {
  git rev-parse --show-toplevel >/dev/null 2>&1 || return
  local reply
  read -r "reply?Discard all uncommitted tracked changes? [y/N] "
  if [[ "$reply" == [yY] ]]; then
    git reset --hard HEAD
  else
    echo "Cancelled."
  fi
}

# Python ----------------------------------------------------------------------
unalias mkvenv 2>/dev/null
mkvenv() {
  uv venv --python 3.14 --seed --prompt "${1:-py}" && source .venv/bin/activate
}

alias actvenv="source .venv/bin/activate"

# Utilities -------------------------------------------------------------------
alias bu='brew upgrade'
alias cgerb='~/.cgerb.sh'
alias ss='python3 ~/.screenshot.py'

# Zoxide (keep initialization last) --------------------------------------------
# Visit folders with cd, then jump back using keywords such as: z pcb.
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
