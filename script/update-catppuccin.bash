#!/usr/bin/env bash

set -e

if [ -z "$DOTFILES" ]; then 
  echo "DOTFILE dir not found"
  exit 1
fi

__flavors=(frappe latte macchiato mocha)

## YAZI ##
__yazi_url="https://raw.githubusercontent.com/catppuccin/yazi/main/themes/"

for flavor in "${__flavors[@]}"; do
  echo "Downloading $flavor..."
  curl "${__yazi_url}${flavor}.toml" -o "$DOTFILES/yazi/flavors/${flavor}.yazi/flavor.toml"
done


# TODO: bat theme
