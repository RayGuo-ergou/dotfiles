#!/bin/bash

set -e

source "$DOTFILES/scripts/utils.sh"

# Install nvim
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# TODO: install yarn, node, pnpm, bun and etc
