#!/usr/bin/env bash

set -euo pipefail

hyprctl activewindow 2>/dev/null | sed -n 's/^\s*title: //p' | head -n 1
