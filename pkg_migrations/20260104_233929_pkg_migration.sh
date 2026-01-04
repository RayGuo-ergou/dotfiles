#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Installing 1 package(s)..."
paru -S --needed --noconfirm 'witr-bin'

echo "========================================"
echo "Migration completed successfully!"
