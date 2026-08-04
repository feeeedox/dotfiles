#!/bin/sh
spicetify apply --no-restart
hyprctl dispatch 'hl.dsp.send_shortcut({mods="CTRL+SHIFT",key="r",window="class:^(Spotify)$"})'