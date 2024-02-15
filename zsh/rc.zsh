source $HOME/.env.sh
source $DOTFILES/zsh/utils.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
source_if_exists $DOTFILES/zsh/p10k.zsh
source_if_exists $DOTFILES/zsh/exports.zsh
source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $DOTFILES/zsh/.p10k.zsh
source_if_exists $DOTFILES/zsh/omz.zsh
source_if_exists $DOTFILES/zsh/init.zsh
source_if_exists $DOTFILES/zsh/aliases.zsh
