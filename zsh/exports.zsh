# ZSH
export ZSH="$HOME/.oh-my-zsh"

export plugins=(
git
git-extras
aliases
docker
ubuntu
bun
tmux
zsh-autosuggestions
# zsh-syntax-highlighting
fast-syntax-highlighting
zsh-vi-mode
you-should-use
colored-man-pages
command-not-found
composer
ssh
copyfile
copypath
cp
gh
fd
ripgrep
)

export ZSH_THEME="powerlevel10k/powerlevel10k"

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"

# Edoitor
export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"

# tmux
# Make sure the tmux omz plugin is installed
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_DEFAULT_SESSION_NAME='森羅万象'

# To tell pnpm not to check packageManager
export COREPACK_ROOT="E"

# eslint_d default to use flat config
export ESLINT_USE_FLAT_CONFIG=true

# bat theme
# mkdir -p "$(bat --config-dir)/themes"
# wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
# wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
# wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
# wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
# bat cache --build
# bat --list-themes
export BAT_THEME="Catppuccin Macchiato"
