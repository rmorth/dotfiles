local mainMod     = "SUPER"
local terminal    = "alacritty"
local fileManager = "dolphin"
local menu        = "fuzzel"

-- hy3 plugin: rebuild with `hyprpm update` once the fork supports v0.57.0
local hy3_so = "/var/cache/hyprpm/rmorth/hy3/hy3.so"
local hy3_file = io.open(hy3_so, "r")
local hy3_available = hy3_file ~= nil
if hy3_file then hy3_file:close() end
if hy3_available then hl.plugin.load(hy3_so) end

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("wl-paste -p -t text --watch wl-copy")
end)

hl.config({
    general = {
        layout = hy3_available and "hy3" or "dwindle",
    },

    misc = {
        disable_splash_rendering = true,
        disable_hyprland_logo    = true,
        force_default_wallpaper  = 0,
    },

    input = {
        follow_mouse = 2,
        sensitivity  = 0.0,
        accel_profile = "flat",
        kb_layout    = "eu",
        kb_options   = "grp:alt_shift_toggle",
        repeat_delay = 250,
        repeat_rate  = 40,
    },

    render = {
        cm_enabled = true,
    },

    binds = {
        allow_workspace_cycles = true,
    },
})

if hy3_available then
    hl.config({
        plugin = {
            hy3 = {
                tabs = {
                    height       = 24,
                    padding      = 6,
                    from_top     = false,
                    radius       = 0,
                    border_width = 1,

                    render_text  = true,
                    text_center  = true,
                    text_font    = "CommitMono Nerd Font Bold",
                    text_height  = 10,
                    text_padding = 3,

                    col = {
                        active                    = 0x800a0604,
                        active_border             = 0xffff8c3a,
                        active_text               = 0xffff8c3a,

                        active_alt_monitor        = 0x40d9a066,
                        active_alt_monitor_border = 0xeed9a066,
                        active_alt_monitor_text   = 0xff0a0604,

                        focused                   = 0x407a5a3a,
                        focused_border            = 0xee7a5a3a,
                        focused_text              = 0xffd9a066,

                        inactive                  = 0x800a0604,
                        inactive_border           = 0xaa4a3525,
                        inactive_text             = 0xff8a6a4a,

                        urgent                    = 0x40c0392b,
                        urgent_border             = 0xeec0392b,
                        urgent_text               = 0xffffffff,

                        locked                    = 0x404a3525,
                        locked_border             = 0xee4a3525,
                        locked_text               = 0xffd9a066,
                    },

                    blur    = true,
                    opacity = 1.0,
                },

                autotile = {
                    enable = false,
                },
            },
        },
    })
end

hl.monitor({
    output   = "DP-1",
    mode     = "3840x2160@240",
    position = "0x0",
    scale    = 1,
    bitdepth = 10,
})


--------------------
---- KEYBINDS  -----
--------------------

hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + Backspace", hl.dsp.global("quickshell:system-toggle"))
hl.bind(mainMod .. " + B",         hl.dsp.global("quickshell:bar-toggle"))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())

-- Focus (vim HJKL)
if hy3_available then
    hl.bind(mainMod .. " + H", hl.dsp["hy3:movefocus"]("l"))
    hl.bind(mainMod .. " + J", hl.dsp["hy3:movefocus"]("d"))
    hl.bind(mainMod .. " + K", hl.dsp["hy3:movefocus"]("u"))
    hl.bind(mainMod .. " + L", hl.dsp["hy3:movefocus"]("r"))
else
    hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
    hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
end

-- Swap windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Mouse drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

-- Resize submap
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("l",      hl.dsp.window.resize({ x =  50, y =   0, relative = true }), { repeating = true })
    hl.bind("h",      hl.dsp.window.resize({ x = -50, y =   0, relative = true }), { repeating = true })
    hl.bind("k",      hl.dsp.window.resize({ x =   0, y = -40, relative = true }), { repeating = true })
    hl.bind("j",      hl.dsp.window.resize({ x =   0, y =  40, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- hy3 tab toggle
if hy3_available then
    hl.bind(mainMod .. " + S", hl.dsp["hy3:changegroup"]("toggletab"))
end

-- Previous workspace
hl.bind(mainMod .. " + Escape", hl.dsp.focus({ workspace = "previous" }))

-- Obsidian scratchpad
hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("obsidian"))

hl.window_rule({
    name      = "obsidian-scratchpad",
    match     = { class = "^(obsidian)$" },
    workspace = "special:obsidian silent",
    float     = true,
    size      = "1200 900",
    center    = true,
})

-- Pin floating window (visible over fullscreen)
hl.bind(mainMod .. " + P", hl.dsp.window.pin({ action = "toggle" }))

-- Floating window rules
hl.window_rule({
    name  = "firefox-pip",
    match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" },
    float = true,
    size  = "640 360",
})

hl.window_rule({
    name  = "firefox-sharing",
    match = { class = "^(firefox)$", title = "^(Firefox — Sharing Indicator)$" },
    float = true,
})

hl.window_rule({
    name  = "file-dialogs",
    match = { title = "^(Open File|Save As|File Upload)$" },
    float = true,
    center = true,
})

-- Auto-pin PiP and sharing indicator windows after they open
hl.on("window.open", function(win)
    local title = win.title or ""
    local class = win.class or ""
    if class == "firefox" and (title == "Picture-in-Picture" or title == "Firefox — Sharing Indicator") then
        hl.dispatch(hl.dsp.window.pin({ window = "address:" .. tostring(win.address) }))
    end
end)

-- QuickShell global shortcuts
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.global("quickshell:wifi-toggle"))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.global("quickshell:audio-toggle"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.global("quickshell:bluetooth-toggle"))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast --freeze save area - | satty --output-filename /tmp/screenshot.png --initial-tool brush --copy-command wl-copy --save-after-copy --early-exit --filename -"))
