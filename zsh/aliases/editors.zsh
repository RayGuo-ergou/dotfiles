alias vim='nvim'
alias resetlazy='rm -rf $HOME/.local/share/nvim/*'

vimf() {
  local file=$(fd --type f --hidden --exclude .git | fzf --reverse)
  if [[ -n $file ]]; then
    nvim "$file"
  fi
}
