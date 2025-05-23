```bash
systemctl --user enable --now waybar.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpolkitagent.service

cd $HOME/.icons # or `/usr/share/icons`
curl -LOsS https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-macchiato-dark-cursors.zip
unzip catppuccin-macchiato-dark-cursors.zip
```
