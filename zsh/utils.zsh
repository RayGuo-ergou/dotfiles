execute_if_command_exists () {
    if command -v "$1" >/dev/null 2>&1; then
        eval "$2"
    else
        echo "Command not found: $1"
    fi
}

source_if_exists () {
    if test -r "$1"; then
        source "$1"

        else
            echo "File not found: $1"
    fi
}

