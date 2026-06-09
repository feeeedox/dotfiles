#!/usr/bin/env bash

SOURCE_FILE="$HOME/.config/hypr/colors/matugen.conf"

TARGET_FILE="$HOME/.config/hypr/colors/matugen.lua"

[ ! -f "$SOURCE_FILE" ] && exit 1

TEMP_FILE=$(mktemp)

echo "-- Generated Matugen files for Hyprland lua" > "$TEMP_FILE"
echo "local M = {}" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"

while IFS= read -r line; do
    if [[ -z "$line" ]]; then
        echo "" >> "$TEMP_FILE"
        continue
    fi

    clean_line=$(echo "$line" | sed -E 's/^\$([a-zA-Z0-9_]+)[[:space:]]*=[[:space:]]*(.*)/M.\1 = "\2"/')
    echo "$clean_line" >> "$TEMP_FILE"

done < "$SOURCE_FILE"

echo "" >> "$TEMP_FILE"
echo "return M" >> "$TEMP_FILE"

cp "$TEMP_FILE" "$TARGET_FILE"

rm "$TEMP_FILE"


hyprctl reload
pgrep hyprlock && pkill -USR1 hyprlock || true
