# Dotfiles

## Install

```bash
git clone <this-repo>
cd <this-repo>

# The script cannot run by POSIX sh.
bash ./install/bootstrap.sh
```

## Local ZSH Config

If there's customization you want ZSH to load on startup that is specific to
this machine (stuff you don't want to commit into the repo), create `~/.env.sh`
and put it in there. It will be loaded near the top of `.zshrc`.

## References

[Here's a description of how my dotfiles work](https://shaky.sh/simple-dotfiles/).
Forked from [andrew8088/dotfiles](https://github.com/andrew8088/dotfiles)
