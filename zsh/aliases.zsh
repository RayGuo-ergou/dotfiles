# alias
alias ls='eza -l --icons -h'
alias cat='bat'
alias nd='nr dev'
alias vim='nvim'
alias configzsh='nvim ~/.zshrc'
alias reload='source ~/.zshrc'
alias aptupdate='sudo apt update && sudo apt upgrade -y'
alias pvm='sudo update-alternatives --config php'
alias jvm='sudo update-alternatives --config java'
alias fe='ESLINT_USE_FLAT_CONFIG=true $HOME/.local/share/nvim/mason/bin/eslint_d restart'
alias ufe='ESLINT_USE_FLAT_CONFIG= $HOME/.local/share/nvim/mason/bin/eslint_d restart'
alias rcd='\cd'
alias resetlazy='rm -rf $HOME/.local/share/nvim/*'
if is_wsl; then
  alias x-www-browser='wslview'
fi
alias php7='/usr/bin/php7.4'
alias windowsroot='wslpath "$(wslvar USERPROFILE)"'
alias yy='yazi'
alias lg='TERM=screen-256color lazygit'
alias cdlazyvim='cd ~/.local/share/nvim/lazy'
alias se='sessionizer'
alias icat='kitty icat'
# journal warning error
alias jourwr='journalctl -p warning..emerg -r'
# see https://forum.endeavouros.com/t/how-to-delete-orphaned-packages-pacman-vs-pamac/45218
alias rmorp='sudo pacman -R $(pacman -Qdtq)'

vimf() {
  local file=$(fd --type f --hidden --exclude .git | fzf --reverse)
  if [[ -n $file ]]; then
    nvim "$file"
  fi
}
cdf() {
  local initial_dir="${1:-$PWD}" # Default to current dir if no dir is specified
  local dir
  # Note: No pattern is specified, so '.' is used to match everything in the specified directory.
  dir=$(fd . "$initial_dir" --type d | fzf --height 40% --reverse --preview 'eza -l --icons -h --color always {}')
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}
alias cdh='cdf $HOME'

