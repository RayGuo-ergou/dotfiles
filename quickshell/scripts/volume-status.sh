#!/usr/bin/env bash

set -euo pipefail

out_line="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)"
in_line="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)"

out_raw="$(printf '%s\n' "$out_line" | awk '{print $2}')"
in_raw="$(printf '%s\n' "$in_line" | awk '{print $2}')"

out_pct=$(awk -v v="$out_raw" 'BEGIN { if (v=="" || v !~ /^[0-9.]+$/) print 0; else printf "%d", (v*100)+0.5 }')
in_pct=$(awk -v v="$in_raw" 'BEGIN { if (v=="" || v !~ /^[0-9.]+$/) print 0; else printf "%d", (v*100)+0.5 }')

out_muted=0
in_muted=0
printf '%s' "$out_line" | grep -q '\[MUTED\]' && out_muted=1
printf '%s' "$in_line" | grep -q '\[MUTED\]' && in_muted=1

printf 'OUT %s %s\nIN %s %s\n' "$out_pct" "$out_muted" "$in_pct" "$in_muted"
