#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Removing 1 package(s)..."
err=$(sudo pacman -Rns --noconfirm 'witr-bin' 2>&1) || echo "$err"

echo "Installing 7 package(s)..."
sudo pacman -S --needed --noconfirm 'aws-cli'
sudo pacman -S --needed --noconfirm 'bind'
sudo pacman -S --needed --noconfirm 'bun'
sudo pacman -S --needed --noconfirm 'hyprlauncher'
sudo pacman -S --needed --noconfirm 'opencode-bin'
sudo pacman -S --needed --noconfirm 'protonplus'
sudo pacman -S --needed --noconfirm 'zip'

echo "========================================"
echo "Migration completed successfully!"
