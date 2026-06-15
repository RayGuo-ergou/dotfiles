#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 2 package(s)..."
sudo pacman -S --needed --noconfirm 'gum'
sudo pacman -S --needed --noconfirm 'just'

echo "========================================"
echo "Migration completed successfully!"
