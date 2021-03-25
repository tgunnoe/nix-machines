#!/usr/bin/env zsh

i3_config="$1"

setopt nobgnice

swaylock='swaylock -fFc F4FBF4'
eval $swaylock
swayidle -w before-sleep "$swaylock" &

xrdb ~/dotfiles/x/Xresources

import-gsettings \
    gtk-theme:gtk-theme-name \
    icon-theme:gtk-icon-theme-name \
    cursor-theme:gtk-cursor-theme-name \
    font-name:gtk-font-name

udiskie -s --appindicator &
redshift-gtk &
nm-applet --indicator &

$BROWSER &
$TERMINAL -name WeeChat -e weechat &
telegram-desktop &
transmission-gtk -m &

/home/tgunnoe/src/nix-machines/pkgs/applications/nixway-app/ws-1.py &

if [[ "$HOST" == "Hitagi" ]]; then
    pkill gebaard; gebaard &
fi
