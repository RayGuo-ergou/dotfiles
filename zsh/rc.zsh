source_if_exists () {
    if test -r "$1"; then
        source "$1"

        else
            echo "File not found: $1"
    fi
}
source $HOME/.env.sh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
source_if_exists ${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh
source_if_exists $DOTFILES/zsh/exports.zsh
source_if_exists $DOTFILES/zsh/aliases.zsh
source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $DOTFILES/zsh/.p10k.zsh
source_if_exists $DOTFILES/zsh/omz.zsh
