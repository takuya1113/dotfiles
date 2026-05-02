local wezterm = require 'wezterm'

wezterm.on("toggle-blur", function(window, pane)
  local overrides = window:get_config_overrides() or {}

  if overrides.macos_window_background_blur then
    -- OFF
    overrides.macos_window_background_blur = nil
  else
    -- ON（好きな値に）
    overrides.macos_window_background_blur = 20
  end

  window:set_config_overrides(overrides)
end)

local config = {}

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.macos_forward_to_ime_modifier_mask = "SHIFT"

-- ===== 見た目 =====
config.initial_cols = 200
config.initial_rows = 60

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85

config.color_scheme = "Kanagawa (Gogh)"

config.font = wezterm.font_with_fallback({
  "JetBrains Mono",
  { family = "Menlo", weight = "Bold" },
  "Hiragino Sans",
})

config.font_size = 13.5
config.bold_brightens_ansi_colors = true

-- タブバー
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_background_gradient = {
  colors = {"#000000"},
}

config.show_new_tab_button_in_tab_bar = false

config.colors = {
  tab_bar = {
    background = "none",
  },
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background

  local raw_title = tab.tab_title and #tab.tab_title > 0 and tab.tab_title or tab.active_pane.title
  local title = "   " .. wezterm.truncate_right(raw_title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

config.adjust_window_size_when_changing_font_size = false
config.keys = {
  {
    key = "Space",
    mods = "CTRL",
    action = wezterm.action.SendKey {
      key = "]",
      mods = "CTRL",
    },
  },
  {
    key = "b",
    mods = "CMD|SHIFT",
    action = wezterm.action.EmitEvent "toggle-blur",
  },
}

return config
