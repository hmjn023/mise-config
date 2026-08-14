local main_mod = "SUPER"
local shift_mod = "SUPER + SHIFT"

local function bind(key, dispatcher, options)
    hl.bind(key, dispatcher, options)
end

local function command(key, value, options)
    bind(key, hl.dsp.exec_cmd(value), options)
end

-- Applications
command(main_mod .. " + T", "kitty")
command(main_mod .. " + Return", "wezterm")
command(main_mod .. " + E", "dolphin")
command(main_mod .. " + D", "wofi --show drun -I")
command("CTRL + SHIFT + Escape", "kitty btop")
command(shift_mod .. " + T", "kitty iwctl")
command(main_mod .. " + W", "$HOME/eww.sh")
command(shift_mod .. " + W", "$HOME/side.sh")

-- System
bind(shift_mod .. " + Q", hl.dsp.window.close())
command(shift_mod .. " + E", "hyprshutdown")
bind(shift_mod .. " + Space", hl.dsp.window.float({ action = "toggle" }))
bind(main_mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
command(shift_mod .. " + L", 'swaylock -f --font "Noto Sans Mono CJK JP" -C "$HOME/.config/swaylock/config"')
command(shift_mod .. " + N", "swaync-client -t -sw")
command(shift_mod .. " + R", "hyprctl reload")

-- Screenshot and OCR
command("CTRL + Print", [=[mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H%M%S_screenshot.png')" && notify-send "Screenshot Saved"]=])
command("Print", [=[mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H%M%S_screenshot.png')" && notify-send "Screenshot Saved"]=])
command(shift_mod .. " + S", 'grim -g "$(slurp)" - | wl-copy')
command(main_mod .. " + O", 'grim -g "$(slurp)" - | tesseract -l eng stdin stdout | sed "s/ //g" | wl-copy')
command(shift_mod .. " + O", 'grim -g "$(slurp)" - | tesseract -l jpn+eng stdin stdout | sed "s/ //g" | wl-copy')

-- Audio and brightness
local media_options = { locked = true }
command("XF86AudioRaiseVolume", "swayosd-client --output-volume raise", media_options)
command("XF86AudioLowerVolume", "swayosd-client --output-volume lower", media_options)
command("XF86AudioMute", "swayosd-client --output-volume mute-toggle", media_options)
-- Fn4 / microphone mute: toggle the default PipeWire capture source directly.
-- This keeps the hotkey independent from swayosd's input-volume support.
command("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", media_options)
command("XF86MonBrightnessUp", "swayosd-client --brightness raise", media_options)
command("XF86MonBrightnessDown", "swayosd-client --brightness lower", media_options)

-- Focus
bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
bind(main_mod .. " + H", hl.dsp.focus({ direction = "left" }))
bind(main_mod .. " + L", hl.dsp.focus({ direction = "right" }))
bind(main_mod .. " + K", hl.dsp.focus({ direction = "up" }))
bind(main_mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(shift_mod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize
bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
local locked = { locked = true }
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), locked)
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), locked)
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), locked)
