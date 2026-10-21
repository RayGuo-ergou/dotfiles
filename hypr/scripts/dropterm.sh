#!/usr/bin/env bash
# Drop-down Ghostty with a persistent tmux session.

CLASS="com.dropterm.ghostty"
SESSION="drop"

if hyprctl monitors -j | jq -e 'any(.[]; .focused and .specialWorkspace.name == "special:dropterm")' >/dev/null; then
  hyprctl dispatch 'hl.dsp.workspace.toggle_special("dropterm")'
  exit
fi

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

# A tmux session can outlive its window. Sync it only if every pane is idle.
if tmux has-session -t "$SESSION" 2>/dev/null; then
  busy=false
  while IFS=' ' read -r command in_mode; do
    if [[ $in_mode != 0 || ($command != zsh && $command != bash) ]]; then
      busy=true
      break
    fi
  done < <(tmux list-panes -s -t "$SESSION" -F '#{pane_current_command} #{pane_in_mode}')
  current_dir=$(tmux display-message -p -t "$SESSION" '#{pane_current_path}')
  if [[ $busy == false && $dir != "$current_dir" ]]; then
    tmux send-keys -t "$SESSION" -l "cd -- ${dir@Q} && clear"
    tmux send-keys -t "$SESSION" Enter
  fi
fi

if hyprctl clients -j | jq -e --arg c "$CLASS" 'any(.[]; .class == $c)' >/dev/null; then
  hyprctl dispatch 'hl.dsp.workspace.toggle_special("dropterm")'
  hyprctl eval 'require("scripts.dropterm").reset()'
else
  setsid -f ghostty --class="$CLASS" --working-directory="$dir" \
    -e tmux new-session -A -s "$SESSION" -c "$dir"
fi
