# Install Nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Adapt install gh normally do
sudo ln -s $HOME/.nix-profile/bin/gh /usr/bin/gh

# To upgrade all pkg
nix profile upgrade --all

nix profile install nixpkgs#delta nixpkgs#gh nixpkgs#git-extras nixpkgs#hyfetch nixpkgs#lazygit nixpkgs#tmux nixpkgs#typos nixpkgs#wslu nixpkgs#xsel nixpkgs#zoxide nixpkgs#fzf nixpkgs#ripgrep nixpkgs#yazi nixpkgs#eza nixpkgs#bat nixpkgs#stripe-cli nixpkgs#gitmux nixpkgs#trash-cli

# For gitmux, have to link to /usr/bin just like gh cli
sudo ln -s $HOME/.nix-profile/bin/gitmux /usr/bin/gitmux

# WARNING: Use with caution
# Remove all pkg and reinstall with flask above
nix profile remove delta gh git-extras hyfetch lazygit tmux typos wslu xsel zoxide fzf ripgrep yazi eza bat

# Yazi 0.3.0 new deps
nix profile install nixpkgs#_7zz
nix profile install nixpkgs#imagemagick
nix profile install nixpkgs#chafa

# ast-grep
nix profile install nixpkgs#ast-grep
# move linux sg
sudo mv /usr/bin/sg{,.bak}

# xmllint
nix profile install nixpkgs#libxml2
