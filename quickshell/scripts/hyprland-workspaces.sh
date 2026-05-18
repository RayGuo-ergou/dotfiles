#!/usr/bin/env bash
set -euo pipefail

printf '__WORKSPACES__\n'
hyprctl workspaces -j 2>/dev/null
printf '\n__MONITORS__\n'
hyprctl monitors -j 2>/dev/null
printf '\n__CLIENTS__\n'
hyprctl clients -j 2>/dev/null
