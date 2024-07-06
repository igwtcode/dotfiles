local wezterm = require("wezterm")
local act = wezterm.action
local conf = {}
local font_name = "CaskaydiaCove Nerd Font"

if wezterm.config_builder then
	conf = wezterm.config_builder()
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

conf.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
-- conf.color_scheme = "Tokyo Night"

conf.macos_window_background_blur = 30
conf.native_macos_fullscreen_mode = false
conf.window_background_opacity = 0.85
conf.window_decorations = "RESIZE"
conf.window_close_confirmation = "AlwaysPrompt"
conf.window_frame = { font_size = 16 }
conf.window_padding = {
	left = 15,
	bottom = 9,
	top = 15,
	right = 15,
}

conf.use_fancy_tab_bar = false
conf.tab_bar_at_bottom = true
conf.hide_tab_bar_if_only_one_tab = true

conf.default_cursor_style = "BlinkingUnderline"
conf.force_reverse_video_cursor = true

conf.font = wezterm.font_with_fallback({
	font_name,
	{ family = font_name, italic = true },
})
conf.font_size = 16
conf.line_height = 1.1
conf.dpi = 144
conf.initial_cols = 90
conf.initial_rows = 30
conf.scrollback_lines = 6000

conf.keys = {
	{
		key = "f",
		mods = "CMD|CTRL",
		action = act.ToggleFullScreen,
	},
}

conf.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

return conf
