local function exec(command)
    hl.exec_cmd(command)
end

local function start_on_workspace(workspace, command)
    hl.exec_cmd(command, { workspace = tostring(workspace) .. " silent" })
end

hl.on("hyprland.start", function()
    exec("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    exec("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    exec("/usr/lib/pam_kwallet_init")
    exec("hyprpaper")
    exec("swayosd-server")
    exec("waybar")
    exec("mako")
    exec("fcitx5")

    start_on_workspace(1, "wezterm")
    start_on_workspace(2, "google-chrome-stable")
    start_on_workspace(9, "discord")
    start_on_workspace(10, "kitty btop")
end)
