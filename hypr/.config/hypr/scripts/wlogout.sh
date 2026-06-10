#!/usr/bin/bash
top_margin=400
bottom_margin=400

if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

height=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .height')
scale=$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale')

logical_height=$(awk "BEGIN {printf \"%.0f\", $height / $scale}")

margin_top=$(awk "BEGIN {printf \"%.0f\", $logical_height * 0.35}")
margin_bottom=$(awk "BEGIN {printf \"%.0f\", $logical_height * 0.40}")
margin_side=$(awk "BEGIN {printf \"%.0f\", $logical_height * 0.20}")

wlogout -C $HOME/.config/wlogout/style.css \
  -l $HOME/.config/wlogout/layout \
  --protocol layer-shell \
  -b 5 \
  -T $margin_top \
  -B $margin_bottom \
  -L $margin_side \
  -R $margin_side \
  -c 10 \
  -r 10 &