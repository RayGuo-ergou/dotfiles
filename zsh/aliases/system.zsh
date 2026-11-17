alias configzsh='nvim ~/.zshrc'
alias reload='source ~/.zshrc'
alias aptupdate='sudo apt update && sudo apt upgrade -y'
if is_wsl; then
  alias x-www-browser='wslview'
fi
alias windowsroot='wslpath "$(wslvar USERPROFILE)"'
# journal warning error
alias jourwr='journalctl -p warning..emerg -r'
# see https://forum.endeavouros.com/t/how-to-delete-orphaned-packages-pacman-vs-pamac/45218
alias rmorp='sudo pacman -R $(pacman -Qdtq)'
