tmux() {
  if (($# == 0)); then
    command tmux new-session -As main
  else
    command tmux "$@"
  fi
}

alias tksv='tmux kill-server'
alias tl='tmux list-sessions'
alias tmuxconf='$EDITOR $ZSH_TMUX_CONFIG'

_build_tmux_alias "ta" "attach" "-t"
_build_tmux_alias "tad" "attach -d" "-t"
_build_tmux_alias "to" "new-session -A" "-s"
_build_tmux_alias "ts" "new-session" "-s"
_build_tmux_alias "tkss" "kill-session" "-t"
