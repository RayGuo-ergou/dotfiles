#!/usr/bin/env bash

set -euo pipefail

monitor_name="$1"
target="$2"
workspace_id="$3"

if [[ "$target" =~ ^[1-9][0-9]*$ ]]; then
    hyprctl dispatch focusmonitor "$monitor_name"
    hypr-local-workspaces goto "$target" --no-compact
else
    hyprctl dispatch "hl.dsp.focus({ workspace = \"$workspace_id\" })"
fi
