# Local copies from https://github.com/ohmyzsh/ohmyzsh
# Revision: 6010fb6260f359e71d99ba25f05f9215809b3ed2
# License: LICENSE-omz.txt. No Oh My Zsh installation is loaded.

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

for plugin in $plugins; do
  if [[ -d "$DOTFILES/zsh/vendor/$plugin" ]]; then
    fpath=("$DOTFILES/zsh/vendor/$plugin" $fpath)
  else
    fpath=("$DOTFILES/zsh/plugins/$plugin" $fpath)
  fi
done

autoload -Uz compinit
compinit -i -d "$ZSH_CACHE_DIR/zcompdump-$ZSH_VERSION"

for plugin in $plugins; do
  if [[ -d "$DOTFILES/zsh/vendor/$plugin" ]]; then
    source_if_exists "$DOTFILES/zsh/vendor/$plugin/$plugin.plugin.zsh"
  else
    source_if_exists "$DOTFILES/zsh/plugins/$plugin/$plugin.plugin.zsh"
  fi
done
unset plugin

source_if_exists "$DOTFILES/zsh/vendor/powerlevel10k/powerlevel10k.zsh-theme"
