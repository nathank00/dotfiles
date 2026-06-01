-- ~/.wezterm.lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.default_prog = { "wsl.exe", "--distribution", "Ubuntu", "--exec", "zsh", "-l" }

-- ===== Window & transparency =====
config.enable_wayland = true
config.front_end = "WebGpu"
config.window_background_opacity = 0.5      -- ~50% see-through
config.text_background_opacity = 0.5
config.macos_window_background_blur = 0     -- ignored on Linux; safe to leave
config.window_padding = { left = 12, right = 12, top = 2, bottom = 0 }

-- Minimal decorations: integrated buttons + resize, tab bar acts as titlebar
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false -- keep a minimal header visible
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 24
config.show_tab_index_in_tab_bar = false

config.line_height = 1.1
config.cell_width = 0.95
config.harfbuzz_features = { "calt=1", "liga=1" }

-- ===== Colors (Dracula with purple/teal emphasis) =====
config.colors = {
  foreground = "#F8F8F2",
  background = "#282A36",
  cursor_bg = "#BD93F9",
  cursor_border = "#BD93F9",
  cursor_fg = "#282A36",
  selection_bg = "#44475A",
  selection_fg = "#F8F8F2",

  ansi = {
    "#21222C", "#FF5555", "#50FA7B", "#F1FA8C",
    "#BD93F9", "#FF79C6", "#8BE9FD", "#F8F8F2",
  },
  brights = {
    "#6272A4", "#FF6E6E", "#69FF94", "#FFFFA5",
    "#D6ACFF", "#FF92DF", "#A4FFFF", "#FFFFFF",
  },

  -- Minimal, dark-black header (tab bar)
  tab_bar = {
    background = "#000000",
    active_tab = {
      bg_color = "#000000",
      fg_color = "#BD93F9",
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#000000",
      fg_color = "#6272A4",
    },
    inactive_tab_hover = {
      bg_color = "#000000",
      fg_color = "#8BE9FD",
      italic = true,
    },
    new_tab = { bg_color = "#000000", fg_color = "#6272A4" },
    new_tab_hover = { bg_color = "#000000", fg_color = "#8BE9FD", italic = true },
  },
}

-- Subtle dim for inactive panes
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.8 }

-- Font
config.font = wezterm.font("Hack")
config.font_size = 13

-- ===== Add spacing between tab titles =====
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  -- Add padding on both sides of the tab title
  return {
    { Text = "  " .. title .. "  " },
  }
end)

return config

