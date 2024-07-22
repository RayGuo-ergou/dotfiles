#!/usr/bin/env bash


echo 'Do not use this script directly'
exit 0;

# --- System ---
# TODO: How should I use nixpkg, or aur is enough?
sudo pacman -S  base-devel git cmake zsh bat zoxide tmux eza fzf ripgrep fd xsel git-delta github-cli

cd ~/git && pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay git-extras


# --- NodeJs ---
# Install n
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH
curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
# use npm to install for version management otherwise can save the stdout from above into /usr/bin
npm install -g n
# enable corepack
corepack enable
corepack enable pnpm

# add ni
pnpm add -g @antfu/ni


# --- ZSH ---

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# this plugin has conflicts with fzf
# git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH_CUSTOM/plugins/zsh-vi-mode"

