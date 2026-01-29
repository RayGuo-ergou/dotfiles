#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Removing 1 package(s)..."
err=$(paru -Rns --noconfirm 'witr-bin' 2>&1) || echo "$err"

echo "Installing 7 package(s)..."
paru -S --needed --noconfirm 'aws-cli'
paru -S --needed --noconfirm 'bind'
paru -S --needed --noconfirm 'bun'
paru -S --needed --noconfirm 'hyprlauncher'
paru -S --needed --noconfirm 'opencode-bin'
paru -S --needed --noconfirm 'protonplus'
paru -S --needed --noconfirm 'zip'

echo "========================================"
echo "Migration completed successfully!"
