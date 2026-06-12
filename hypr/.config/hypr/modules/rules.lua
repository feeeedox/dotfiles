--- Window and workspace rules module

hl.workspace_rule({ workspace = "w[tv1]", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "f[1]",   monitor = "DP-1" })

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "firefox-pip",
    match = {
        class = "firefox",
        title = "^Picture-in-Picture$",
    },
    float = true,
    pin   = true,
    size  = "640 360",
    opaque = true,
})

hl.window_rule({
    name = "satty-floating",
    match = { class = "com.gabm.satty" },
    float = true,
})

hl.window_rule({
    name = "swappy-floating",
    match = { class = "swappy" },
    float = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.layer_rule({
    match        = { namespace = "logout_dialog" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match        = { namespace = "swaync-control-center" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match        = { namespace = "swaync-notification-window" },
    blur         = true,
    ignore_alpha = 0.5,
})

hl.window_rule({
    name    = "intellij-blur",
    match   = { class = "jetbrains-idea" },
    opacity = "0.90",
    opaque  = false,
})

hl.window_rule({
    name    = "vesktop-blur",
    match   = { class = "vesktop" },
    opacity = "0.90",
    opaque  = false,
})

hl.layer_rule({
    name     = "rofi",
    match    = { namespace = "rofi" },
    blur     = true,
    animation = "popin 87%",
})
