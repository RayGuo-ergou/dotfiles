```bash
systemctl --user enable --now waybar.service
systemctl --user enable --now hypridle.service
systemctl --user enable --now hyprpolkitagent.service
systemctl --user enable --now swaync.service
systemctl --user enable --now hyprpaper.service

sudo usermod -aG input $USER # For ydotool

cd $HOME/.icons # or `/usr/share/icons`
curl -LOsS https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-macchiato-dark-cursors.zip
unzip catppuccin-macchiato-dark-cursors.zip
# For firefox use theme for thunar
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
```
