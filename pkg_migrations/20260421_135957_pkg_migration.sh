#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 3 package(s)..."
paru -S --needed --noconfirm 'usb_modeswitch'
paru -S --needed --noconfirm 'wireguard-tools'
paru -S --needed --noconfirm 'zoom'

echo "========================================"
echo "Migration completed successfully!"
