#!/usr/bin/env bash

set -euo pipefail

pct="${1:-0}"
wpctl set-volume @DEFAULT_AUDIO_SINK@ "$pct"% >/dev/null 2>&1
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 >/dev/null 2>&1
