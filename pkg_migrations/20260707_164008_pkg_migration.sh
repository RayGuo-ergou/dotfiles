#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 1 package(s)..."
sudo pacman -S --needed --noconfirm 'zig'

echo "========================================"
echo "Migration completed successfully!"
