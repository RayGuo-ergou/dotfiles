# Check if a command exists
command_exists() {
  # This will return 0 (true in shell scripting) if the command exists,
  # and 1 (false) if it does not.
  info "Checking if $1 exists"
  command -v "$1" > /dev/null 2>&1
}

install_command() {
  local cmd_to_check="$1"
  local install_cmd="$2"

  if ! command_exists $cmd_to_check; then
    info "$cmd_to_check not found! Installing..."
    
    # Capture the output and errors of the evaluated command
    local output=$(eval $install_cmd 2>&1)
    
    # Check the exit status of the evaluated command
    if [ $? -eq 0 ]; then
      success "$cmd_to_check installed!"
      info "$output"
    else
      fail "$output"
    fi
  else
    echo "$cmd_to_check is already installed!"
  fi
}

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}