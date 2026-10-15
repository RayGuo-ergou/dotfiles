#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 3 package(s)..."
sudo pacman -S --needed --noconfirm 'php-gd'
sudo pacman -S --needed --noconfirm 'php-sodium'
sudo pacman -S --needed --noconfirm 'smartmontools'

echo "========================================"
echo "Migration completed successfully!"
