#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)

# Finish installing the pinned dependencies before removing the old installation.
git -C "$root" submodule update --init --recursive

for file in .zshrc .zshenv; do
  if [[ ! "$HOME/$file" -ef "$root/zsh/rc.zsh" ]]; then
    printf '%s must point to %s/zsh/rc.zsh first.\n' "$HOME/$file" "$root" >&2
    printf 'Run: bash "%s/install/bootstrap.sh"\n' "$root" >&2
    exit 1
  fi
done

cache="${XDG_CACHE_HOME:-$HOME/.cache}"
user=$(id -un)

printf 'This will delete %s, including its custom plugins and themes.\n' "$HOME/.oh-my-zsh"
printf 'Old OMZ and generated Powerlevel10k caches will also be removed.\n'
read -r -p 'Continue? [y/N] ' answer
case "$answer" in
  y|Y|yes|YES) ;;
  *) printf 'Cancelled.\n'; exit 0 ;;
esac

# Do not run OMZ's uninstaller: it can replace .zshrc and change the login shell.
rm -rf -- "$HOME/.oh-my-zsh" "$cache/oh-my-zsh"
rm -f -- \
  "$cache/p10k-dump-$user.zsh" \
  "$cache/p10k-dump-$user.zsh.zwc" \
  "$cache/p10k-instant-prompt-$user.zsh" \
  "$cache/p10k-instant-prompt-$user.zsh.zwc"

printf 'Migration complete. Start a fresh shell with: exec zsh\n'
