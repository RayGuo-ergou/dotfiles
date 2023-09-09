#!/bin/bash
set -e

# Find directories containing install.sh and run them
for dir in "$DOTFILES"/scripts/*/; do
    if [[ -f "${dir}/install.sh" ]]; then
        echo "Running install.sh in ${dir}"
        bash "${dir}/install.sh"
    fi
done

echo "All installations are complete!"
