--- Keybindings module

local terminal      = "kitty"
local fileManager   = "thunar"
local menu          = "rofi -show drun -theme ~/.local/share/rofi/themes/minimal.rasi"
local mainMod       = "SUPER"
local clipboardMenu = "/home/fedox/.local/bin/cliphist-rofi" 


--- App-Launcher & Core-Apps
--- ----------------------------------------------------------------------------
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd("pkill rofi || " .. menu))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("walset"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("/home/fedox/.config/waybar/scripts/launch.sh"))

--- Session & System controls
--- ----------------------------------------------------------------------------
hl.bind(mainMod .. " + L",     hl.dsp.exec_cmd("hyprlock"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("~/.config/hypr/scripts/wlogout.sh"))
hl.bind(mainMod .. " + M",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

--- Window Management
--- ----------------------------------------------------------------------------
hl.bind(mainMod .. " + C", hl.dsp.window.close()) -- window-close Bindung (aktiv)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

--- Navigation
--- ----------------------------------------------------------------------------
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

--- Workspace-Management (1 - 10)
--- ----------------------------------------------------------------------------
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace switching with mouse scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

--- Mouse actions for moving and resizing windows
--- ----------------------------------------------------------------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--- Hardware keys (Volume, Brightness, etc.)
--- ----------------------------------------------------------------------------
local mediaKeys = {
    { "XF86AudioRaiseVolume",  "spotify-controller volume-up" },
    { "XF86AudioLowerVolume",  "spotify-controller volume-down" },
    { "XF86AudioMute",         "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { "XF86AudioMicMute",      "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { "XF86MonBrightnessUp",   "brightnessctl -e4 -n2 set 5%+" },
    { "XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-" }
}

for _, cfg in ipairs(mediaKeys) do
    hl.bind(cfg[1], hl.dsp.exec_cmd(cfg[2]), { locked = true, repeating = true })
end

--- Media keys for music control
--- ----------------------------------------------------------------------------
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--- Utilities (screenshot, color picker, etc.)
--- ----------------------------------------------------------------------------
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("sh -c 'hyprshot -m region -o ~/Pictures/Screenshots --raw | satty --filename -'")) -- Screenshot of selected region, saved to ~/Pictures/Screenshots and opened in satty for annotation (requires satty to be installed)
hl.bind(mainMod .. " + H",   hl.dsp.exec_cmd("hyprpicker -a"), { locked = true }) -- Color picker
hl.bind(mainMod .. " + period",   hl.dsp.exec_cmd("omniglyph")) -- Emoji picker (requires omniglyph to be installed)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(clipboardMenu)) -- Clipboard history menu (requires cliphist-rofi script to be installed)