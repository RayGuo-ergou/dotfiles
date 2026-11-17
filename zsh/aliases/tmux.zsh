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

# ALIASES
function _build_tmux_alias {
  setopt localoptions no_rc_expand_param
  eval "function $1 {
    if [[ -z \$1 ]] || [[ \${1:0:1} == '-' ]]; then
      tmux $2 \"\$@\"
    else
      tmux $2 $3 \"\$@\"
    fi
  }"

  local f s
  f="_omz_tmux_alias_${1}"
  s=(${(z)2})

  eval "function ${f}() {
    shift words;
    words=(tmux ${@:2} \$words);
    ((CURRENT+=${#s[@]}+1))
    _tmux
  }"

  compdef "$f" "$1"
}
_build_tmux_alias "ta" "attach" "-t"
_build_tmux_alias "tad" "attach -d" "-t"
_build_tmux_alias "to" "new-session -A" "-s"
_build_tmux_alias "ts" "new-session" "-s"
_build_tmux_alias "tkss" "kill-session" "-t"
