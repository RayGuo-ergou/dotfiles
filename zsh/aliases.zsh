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
alias resetlazy='rm -rf $HOME/.local/share/nvim/*'
alias x-www-browser='wslview'
alias php7='/usr/bin/php7.4'
alias windowsroot='wslpath "$(wslvar USERPROFILE)"'

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
  dir=$(fd . "$initial_dir" --type d | fzf --height 40% --reverse)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}

cdh() {
  local initial_dir="${1:-$HOME}" # Default to current dir if no dir is specified
  local dir
  # Note: No pattern is specified, so '.' is used to match everything in the specified directory.
  dir=$(fd . "$initial_dir" --type d | fzf --height 40% --reverse)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}

yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

