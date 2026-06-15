#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 3 package(s)..."
sudo pacman -S --needed --noconfirm 'usb_modeswitch'
sudo pacman -S --needed --noconfirm 'wireguard-tools'
sudo pacman -S --needed --noconfirm 'zoom'

echo "========================================"
echo "Migration completed successfully!"
