#!/usr/bin/env bash

set -euo pipefail

pct="${1:-0}"
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ "$pct"% >/dev/null 2>&1
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 >/dev/null 2>&1
