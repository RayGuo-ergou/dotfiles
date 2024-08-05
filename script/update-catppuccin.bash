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
  echo "Downloading yazi $flavor..."
  curl "${__yazi_url}${flavor}.toml" -o "$DOTFILES/yazi/flavors/${flavor}.yazi/flavor.toml"
done


## Bat ##
__bat_url="https://raw.githubusercontent.com/catppuccin/bat/main/themes/"
for flavor in "${__flavors[@]}"; do
  yazi_theme_file="$DOTFILES/yazi/flavors/${flavor}.yazi/tmtheme.xml"
  bat_theme_file="$DOTFILES/bat/themes/Catppuccin ${flavor^}.tmTheme"
  echo "Downloading bash $flavor..."
  curl "${__bat_url}Catppuccin%20${flavor^}.tmTheme" -o "${bat_theme_file}"
  echo "Download finished, copying to yazi themes..."
  cp "${bat_theme_file}" "${yazi_theme_file}"
done


