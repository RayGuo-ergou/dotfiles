# Switch to bash in raw TTY
if [[ $(tty) == /dev/tty* ]]; then
	if uwsm check may-start; then
		exec uwsm start hyprland.desktop
	else
		exec bash
	fi
fi

# Doc: https://zsh.sourceforge.io/Doc/Release/
source $HOME/.env.sh
source $DOTFILES/zsh/utils.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
source_if_exists $HOME/.config/user-dirs.dirs
source_if_exists $DOTFILES/zsh/p10k.zsh
source_if_exists $DOTFILES/zsh/exports.zsh
source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $DOTFILES/zsh/.p10k.zsh
source_if_exists $DOTFILES/zsh/omz.zsh
source_if_exists $DOTFILES/zsh/init.zsh
source_if_exists $DOTFILES/zsh/aliases.zsh
source_if_exists $DOTFILES/zsh/post_init.zsh
