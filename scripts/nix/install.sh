# Install Nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# packages
nix-env -iA nixpkgs.wslu
nix-env -iA nixpkgs.eza
nix-env -iA nixpkgs.zoxide
nix-env -iA nixpkgs.tmux
nix-env -iA nixpkgs.git-extras
nix-env -iA nixpkgs.delta
nix-env -iA nixpkgs.gh
# Adapt install gh normally do
# sudo ln -s $HOME/.nix-profile/bin/gh /usr/bin/gh
nix-env -iA nixpkgs.zoxide

nix-env -iA nixpkgs.bat
