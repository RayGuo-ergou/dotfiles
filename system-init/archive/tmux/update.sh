#!/usr/bin/env bash

set -e

# dependencies
sudo apt update
sudo apt install -y git automake build-essential pkg-config libevent-dev libncurses5-dev byacc

# where our temp file locates
rm -rf /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux
cd /tmp/tmux

bash autogen.sh
./configure && make
make install
cd -

# clean up
rm -rf /tmp/tmux
