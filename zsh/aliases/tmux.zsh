tmux() {
  if (( $# == 0 )); then
    command tmux new-session -As main
  else
    command tmux "$@"
  fi
}
