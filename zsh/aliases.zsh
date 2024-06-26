# alias
alias ls='eza -l --icons -h'
alias cat='bat'
alias pnd='pnpm dev'
alias vim='nvim'
alias configzsh='nvim ~/.zshrc'
alias reload='source ~/.zshrc'
alias aptupdate='sudo apt update && sudo apt upgrade -y'
alias pvm='sudo update-alternatives --config php'
alias jvm='sudo update-alternatives --config java'
alias fe='ESLINT_USE_FLAT_CONFIG=true $HOME/.local/share/nvim/mason/bin/eslint_d restart'
alias ufe='ESLINT_USE_FLAT_CONFIG= $HOME/.local/share/nvim/mason/bin/eslint_d restart'
alias rcd='\cd'
alias cd='__zoxide_z'
alias cdi='__zoxide_zi'
alias resetlazy='rm -rf $HOME/.local/share/nvim/*'
alias x-www-browser='wslview'
alias php7='/usr/bin/php7.4'
alias windowsroot='wslpath "$(wslvar USERPROFILE)"'
