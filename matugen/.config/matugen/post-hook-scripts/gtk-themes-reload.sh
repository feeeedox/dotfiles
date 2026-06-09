#!/usr/bin/env bash

# 1. Den normalen Farbwechsel-Toggle durchführen (für alle anderen GTK-Apps)
current=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$current" == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
fi

# 2. DER TRICK FÜR NAUTILUS:
# Wir senden ein Signal über D-Bus, das Nautilus zwingt, seine UI-Ressourcen neu zu laden,
# OHNE dass der Prozess stirbt oder deine offenen Tabs geschlossen werden.
if pgrep -x "nautilus" > /dev/null; then
    dbus-send --session --dest=org.gnome.Nautilus --type=method_call /org/gnome/Nautilus org.freedesktop.Actions.Activate string:'reload' array:objpath:[] dict:string:variant:{} &>/dev/null
    
    # Falls der D-Bus-Reload in deiner Nautilus-Version zickt, nutzen wir den sanften "Weckruf" via gsettings-Erzwingung:
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    sleep 0.05
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi