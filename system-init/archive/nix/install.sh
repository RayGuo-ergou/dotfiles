# Install Nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# Adapt install gh normally do
sudo ln -s $HOME/.nix-profile/bin/gh /usr/bin/gh

# To upgrade all pkg
nix profile upgrade --all

nix profile install nixpkgs#delta nixpkgs#gh nixpkgs#git-extras nixpkgs#hyfetch nixpkgs#lazygit nixpkgs#tmux nixpkgs#typos nixpkgs#wslu nixpkgs#xsel nixpkgs#zoxide nixpkgs#fzf nixpkgs#ripgrep nixpkgs#yazi nixpkgs#eza

# WARNING: Use with caution
# Remove all pkg and reinstall with flask above
nix profile remove delta gh git-extras hyfetch lazygit tmux typos wslu xsel zoxide fzf ripgrep yazi eza

