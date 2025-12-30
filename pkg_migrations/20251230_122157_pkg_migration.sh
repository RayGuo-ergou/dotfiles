#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Removing 2 package(s)..."
paru -Rns --noconfirm 'yay' 2>/dev/null || echo "Package 'yay' not found, skipping..."
paru -Rns --noconfirm 'yay-debug' 2>/dev/null || echo "Package 'yay-debug' not found, skipping..."

echo "========================================"
echo "Migration completed successfully!"
