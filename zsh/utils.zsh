execute_if_command_exists() {
    if command -v "$1" >/dev/null 2>&1; then
        eval "$2"
    else
        echo "Command not found: $1"
    fi
}

source_if_exists() {
    if test -r "$1"; then
        source "$1"
    else
        echo "File not found: $1"
    fi
}

nvf() {
    local file=$(fd --type f --hidden --exclude .git | fzf-tmux -p --reverse)
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


