# ZSH
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    tmux
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
    you-should-use
)
ZSH_THEME="powerlevel10k/powerlevel10k"

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
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_DEFAULT_SESSION_NAME='森羅万象'

