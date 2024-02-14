# TODO: Check if the command exists before running it

# zoxide init
eval "$(zoxide init zsh)"

# github copilot cli
eval "$(github-copilot-cli alias -- "$0")"

# add brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

