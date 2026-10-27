# Fade prompt
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz promptinit
promptinit
# Colours: fade bar/folder, username/computer, date/time.
prompt fade green black white
# Show just the username in the prompt.
PS1="${PS1//@%m/}"
# Date format: Tue 27 Oct.
fade_old_date='%D{%a %b %d}'
fade_new_date='%D{%a %d %b}'
PS1="${PS1//$fade_old_date/$fade_new_date}"
unset fade_old_date fade_new_date
# Time format: 24-hour clock with seconds.
fade_old_time='%D{%I:%M:%S%P}'
fade_new_time='%D{%H:%M:%S}'
PS1="${PS1//$fade_old_time/$fade_new_time}"
unset fade_old_time fade_new_time
# Use the terminal's default background outside the green bar.
fade_black_background='%K{black}'
PS1="${PS1//$fade_black_background/%k}"
PS2="${PS2//$fade_black_background/%k}"
unset fade_black_background

# Show Git status and the active Python environment beside the folder.
# psvar keeps names as display text, not prompt instructions.
export VIRTUAL_ENV_DISABLE_PROMPT=1
autoload -Uz add-zsh-hook
fade_git_prompt() {
  local repo_root branch git_changes ahead
  psvar[1]=''
  psvar[2]=''
  if [[ -n "$VIRTUAL_ENV" ]]; then
    psvar[2]="${VIRTUAL_ENV_PROMPT:-${VIRTUAL_ENV:t}}"
  elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
    psvar[2]="$CONDA_DEFAULT_ENV"
  fi
  repo_root=$(command git rev-parse --show-toplevel 2>/dev/null) || return 0
  branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    branch=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
  psvar[1]="${repo_root:t}:$branch"
  git_changes=$(command git --no-optional-locks status --porcelain --untracked-files=normal 2>/dev/null)
  [[ -n "$git_changes" ]] && psvar[1]+=' *'
  # Compare with the last fetched upstream; never fetch from the prompt.
  ahead=$(command git rev-list --count '@{upstream}..HEAD' 2>/dev/null) || ahead=0
  (( ahead > 0 )) && psvar[1]+=" ↑$ahead"
  return 0
}
add-zsh-hook -d precmd fade_git_prompt
add-zsh-hook precmd fade_git_prompt
PS1+='%(1V.%F{cyan}[%1v]%f .)%(2V.%F{yellow}[py:%2v]%f .)'
