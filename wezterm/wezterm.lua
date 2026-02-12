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

config.font_size = 15.5
config.bold_brightens_ansi_colors = true

-- タブバー
config.enable_tab_bar = true
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

-- ===== 操作系（今回追加する部分） =====

-- leader（Windows側と揃える）
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1200 }

config.keys = {
  -- 分割（vim寄せ）
  { key = "v", mods = "LEADER",
    action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "s", mods = "LEADER",
    action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },

  -- ペイン移動
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Left" },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Down" },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Up" },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection "Right" },

  -- タブ操作（macでも有効に）
  { key = "t", mods = "LEADER", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
  {
    key = ",",
    mods = "LEADER",
    action = wezterm.action.PromptInputLine {
      description = "Rename tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line == nil then
          return
        end
        local tab = window:active_tab()
        if not tab then
          return
        end
        tab:set_title(line)
      end),
    },
  },
  { key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = "Q", mods = "LEADER", action = wezterm.action.QuitApplication },

  -- Copy Mode（ログ取得用）
  { key = "y", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
    -- リサイズモード
  {
    key = "r",
    mods = "LEADER",
    action = wezterm.action.ActivateKeyTable {
      name = "resize_pane",
      one_shot = false,
      timeout_milliseconds = 3000,
    },
  },
  {
    key = "b",
    mods = "LEADER",
    action = wezterm.action.EmitEvent "toggle-blur",
  },
}

config.key_tables = {
  copy_mode = {
    { key = "h", action = wezterm.action.CopyMode "MoveLeft" },
    { key = "j", action = wezterm.action.CopyMode "MoveDown" },
    { key = "k", action = wezterm.action.CopyMode "MoveUp" },
    { key = "l", action = wezterm.action.CopyMode "MoveRight" },
    { key = "u", action = wezterm.action.CopyMode "PageUp" },
    { key = "d", action = wezterm.action.CopyMode "PageDown" },

    { key = "0", action = wezterm.action.CopyMode "MoveToStartOfLine" },
    { key = "g", action = wezterm.action.CopyMode "MoveToScrollbackTop" },
    { key = "G", action = wezterm.action.CopyMode "MoveToScrollbackBottom" },

    { key = "/", action = wezterm.action.Search { CaseInSensitiveString = "" } },
    { key = "n", action = wezterm.action.CopyMode "NextMatch" },
    { key = "N", action = wezterm.action.CopyMode "PriorMatch" },
    {
      key = "P",
      action = wezterm.action.Multiple {
        wezterm.action.Search { Regex = "^❯ " },
        wezterm.action.CopyMode "PriorMatch",
      },
    },

    { key = "v", action = wezterm.action.CopyMode { SetSelectionMode = "Cell" } },
    { key = "V", action = wezterm.action.CopyMode { SetSelectionMode = "Line" } },

    {
      key = "y",
      action = wezterm.action.Multiple {
        wezterm.action.CopyTo "Clipboard",
        wezterm.action.CopyMode "Close",
      },
    },

    { key = "Escape", action = wezterm.action.CopyMode "Close" },
    { key = "q", action = wezterm.action.CopyMode "Close" },
  },

  resize_pane = {
    { key = "h", action = wezterm.action.AdjustPaneSize { "Left",  3 } },
    { key = "j", action = wezterm.action.AdjustPaneSize { "Down",  2 } },
    { key = "k", action = wezterm.action.AdjustPaneSize { "Up",    2 } },
    { key = "l", action = wezterm.action.AdjustPaneSize { "Right", 3 } },

    { key = "Escape", action = wezterm.action.PopKeyTable },
    { key = "Enter",  action = wezterm.action.PopKeyTable },
  },
}

return config
