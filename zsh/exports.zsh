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
zsh-syntax-highlighting
# fast-syntax-highlighting
# zsh-vi-mode
you-should-use
vi-mode
colored-man-pages
command-not-found
composer
ssh
copyfile
copypath
cp
gh
)

export ZSH_THEME="powerlevel10k/powerlevel10k"

# n node
# sudo rm -rf /usr/local/bin/{npm,npx,corepack,node,yarn,yarnpkg,pnpx,pnpm}
# sudo rm -rf /usr/local/lib/node_modules
export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

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
export ZSH_TMUX_DEFAULT_SESSION_NAME='至人無己，神人無功，聖人無名'

# To tell pnpm not to check packageManager
# export COREPACK_ROOT="E"

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

# https://github.com/catppuccin/fzf
# Removed bg so it's transparent
export FZF_DEFAULT_OPTS="
--preview 'bat --style=numbers --color=always --line-range :300 {}'
--bind 'ctrl-y:execute-silent(readlink -f {} | xsel -b)'
--bind ctrl-b:preview-page-up,ctrl-f:preview-page-down
--bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down
--bind shift-up:preview-top,shift-down:preview-bottom
--bind alt-up:half-page-up,alt-down:half-page-down
--color=bg+:#303347,spinner:#f4dbd6,hl:#ed8796
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
--multi"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xsel -b)'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

  # Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

  # Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# vi-mode config
export VI_MODE_SET_CURSOR=true

# Add zsh-completions
fpath=($HOME/.zsh-complete $fpath)
