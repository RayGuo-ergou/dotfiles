alias ls='eza -l --icons -h'
alias rcd='\cd'
alias cdlazyvim='cd ~/.local/share/nvim/lazy'

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

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
