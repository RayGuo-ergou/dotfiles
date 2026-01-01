#!/usr/bin/env bash
set -e

echo "Running package migration: $(basename "$0")"
echo "========================================"


echo "Removing 1 package(s)..."
err=$(paru -Rns --noconfirm 'hyprsysteminfo' 2>&1) || echo "$err"

echo "========================================"
echo "Migration completed successfully!"
