# Nix
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# zoxide initialization
execute_if_command_exists "zoxide" "$(zoxide init zsh)"

# fzf initialization
execute_if_command_exists "fzf" "source <(fzf --zsh)"
# Remove alt-c for vi mode
# see: https://github.com/junegunn/fzf/issues/1238#issuecomment-381083777
[[ $- =~ i ]] && bindkey -M vicmd -r '\ec'

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# GitHub Copilot CLI setup
# To install gh extension install github/gh-copilot
# To upgrade gh extension upgrade gh-copilot
# eval "$(gh copilot alias -- zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
		. "$HOME/miniconda3/etc/profile.d/conda.sh"
	else
		export PATH="$HOME/miniconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Init sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Init tpm
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && ~/.tmux/plugins/tpm/bin/install_plugins
fi

###-begin-pnpm-completion-###
if type complete &>/dev/null; then
	_pnpm_completion() {
		local words cword
		if type _get_comp_words_by_ref &>/dev/null; then
			_get_comp_words_by_ref -n = -n @ -n : -w words -i cword
		else
			cword="$COMP_CWORD"
			words=("${COMP_WORDS[@]}")
		fi

		local si="$IFS"
		IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
			COMP_LINE="$COMP_LINE" \
			COMP_POINT="$COMP_POINT" \
			SHELL=bash \
			pnpm completion-server -- "${words[@]}" \
			2>/dev/null)) || return $?
		IFS="$si"

		if [ "$COMPREPLY" = "__tabtab_complete_files__" ]; then
			COMPREPLY=($(compgen -f -- "$cword"))
		fi

		if type __ltrim_colon_completions &>/dev/null; then
			__ltrim_colon_completions "${words[cword]}"
		fi
	}
	complete -o default -F _pnpm_completion pnpm
fi
###-end-pnpm-completion-###

# init cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if command -v carapace >/dev/null 2>&1; then
	export CARAPACE_BRIDGES="zsh,fish,bash,inshellisense"
	zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
	zstyle ":completion:*:git:*" group-order "main commands" "alias commands" "external commands"
	source <(carapace _carapace)
fi

# fzf-tab
zstyle ':fzf-tab:*' fzf-flags --color=bg+:#303347,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
zstyle ':fzf-tab:*' query-string '' #https://github.com/Aloxaf/fzf-tab/issues/32#issuecomment-1519639800
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# disable autocd
unsetopt autocd
