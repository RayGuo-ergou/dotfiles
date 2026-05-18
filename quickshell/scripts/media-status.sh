#!/usr/bin/env bash

set -euo pipefail

line="$(playerctl -a metadata --format '{{status}}|{{playerName}}|{{artist}}|{{title}}|{{album}}' 2>/dev/null | awk -F'|' '$1 == "Playing" { print; exit }')"
[ -z "$line" ] && exit 0

status="$(printf '%s\n' "$line" | cut -d'|' -f1)"
player="$(printf '%s\n' "$line" | cut -d'|' -f2)"
artist="$(printf '%s\n' "$line" | cut -d'|' -f3)"
title="$(printf '%s\n' "$line" | cut -d'|' -f4)"
album="$(printf '%s\n' "$line" | cut -d'|' -f5)"

printf 'STATUS %s\nPLAYER %s\nARTIST %s\nTITLE %s\nALBUM %s\n' "$status" "$player" "$artist" "$title" "$album"
