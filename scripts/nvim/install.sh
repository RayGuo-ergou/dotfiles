#!/bin/bash
set -e

sudo apt install -y xsel fzf fd-find ripgrep

ln -s "$(which fdfind)" ~/.local/bin/fd
# or sudo ln -s $(which fdfind) /usr/bin/fd

