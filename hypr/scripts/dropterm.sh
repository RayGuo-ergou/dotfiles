#!/usr/bin/env bash
# Drop-down Ghostty with a persistent tmux session.

CLASS="com.dropterm.ghostty"
SESSION="drop"

dir=""
active=$(hyprctl activewindow -j)
class=$(jq -r '.class // empty' <<<"$active")
window_pid=$(jq -r '.pid // empty' <<<"$active")

belongs_to_window() {
  pstree -sp "$1" 2>/dev/null | grep -qF "($window_pid)"
}

if [[ $class == com.mitchellh.ghostty ]]; then
  while IFS=' ' read -r client_pid session_name pane_dir; do
    [[ $session_name == "$SESSION" ]] && continue
    if belongs_to_window "$client_pid"; then
      dir=$pane_dir
      break
    fi
  done < <(tmux list-clients -F '#{client_pid} #{session_name} #{pane_current_path}' 2>/dev/null)

  # Without tmux, use the current directory of Ghostty's shell.
  if [[ ! -d $dir && $window_pid =~ ^[0-9]+$ ]]; then
    while read -r shell_pid; do
      dir=$(readlink "/proc/$shell_pid/cwd" 2>/dev/null)
      [[ -d $dir ]] && break
    done < <(pgrep -P "$window_pid" -x 'zsh|bash|fish|sh|dash|nu')
  fi
fi
[[ -d $dir ]] || dir="$HOME"

# Sync only an idle shell; leave running commands and the hiding drawer alone.
if [[ $class != "$CLASS" ]] && tmux has-session -t "$SESSION" 2>/dev/null; then
  idle=$(tmux display-message -p -t "$SESSION" '#{pane_current_command}')
  current_dir=$(tmux display-message -p -t "$SESSION" '#{pane_current_path}')
  if [[ $dir != "$current_dir" && ($idle == zsh || $idle == bash) ]]; then
    tmux send-keys -t "$SESSION" -l "cd -- ${dir@Q} && clear"
    tmux send-keys -t "$SESSION" Enter
  fi
fi

if hyprctl clients -j | jq -e --arg c "$CLASS" 'any(.[]; .class == $c)' >/dev/null; then
  hyprctl dispatch 'hl.dsp.workspace.toggle_special("dropterm")'
else
  setsid -f ghostty --class="$CLASS" --working-directory="$dir" \
    -e tmux new-session -A -s "$SESSION" -c "$dir"
fi
