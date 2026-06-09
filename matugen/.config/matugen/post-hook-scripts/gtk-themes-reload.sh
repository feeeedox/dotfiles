#!/usr/bin/env bash

current=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$current" == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi

if pgrep -x "nautilus" > /dev/null; then
    dbus-send --session --dest=org.gnome.Nautilus --type=method_call /org/gnome/Nautilus org.freedesktop.Actions.Activate string:'reload' array:objpath:[] dict:string:variant:{} &>/dev/null
    

    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    sleep 0.05
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi
