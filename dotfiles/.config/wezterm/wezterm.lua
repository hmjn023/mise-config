local wezterm = require("wezterm")
-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
--config.color_scheme = "AdventureTime"
config.color_scheme = "Ayu Mirage"
config.font = wezterm.font("Moralerspace Neon")
config.font_size = 24.0
config.window_background_opacity = 0.7
config.enable_wayland = true
config.keys = {
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\n"),
	},
}

-- and finally, return the configuration to wezterm
return config
