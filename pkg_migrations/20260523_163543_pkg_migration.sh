#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Removing 1 package(s)..."
err=$(sudo pacman -Rns --noconfirm 'opencode-bin' 2>&1) || echo "$err"

echo "Installing 1 package(s)..."
sudo pacman -S --needed --noconfirm 'opencode'

echo "========================================"
echo "Migration completed successfully!"
