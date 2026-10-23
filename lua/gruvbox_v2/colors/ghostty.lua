--- Gruvbox v2 Ghostty Colors
--- Uses Ghostty's built-in default theme (background #282c34, foreground #ffffff, Tomorrow Night palette)
--- instead of Gruvbox colors. Enabled with `ghostty = true`; contrast has no effect in this mode.

local M = {
  dark = {
    -- Backgrounds & dark shades
    bg_dark = "#21242b",
    bg_buffer = "#282c34",
    bg0 = "#282c34",
    bg1 = "#373b42",
    bg2 = "#464a50",
    bg3 = "#606369",
    bg4 = "#7a7c81",

    -- Foregrounds & light shades
    fg0 = "#ffffff",
    fg1 = "#ffffff",
    fg2 = "#eaeaea",
    fg3 = "#c5c8c6",
    fg4 = "#9e9e9e",

    -- Accent colors (Ghostty bright palette 9-14)
    red = "#d54e53",
    green = "#b9ca4a",
    yellow = "#e7c547",
    blue = "#7aa6da",
    purple = "#c397d8",
    aqua = "#70c0b1",
    orange = "#de935f",
    gray = "#808080",
    pink = "#f0a1a8", -- light pastel red for parameters (Catppuccin maroon-like)

    -- Neutral tones (Ghostty palette 1-6)
    neutral_red = "#cc6666",
    neutral_green = "#b5bd68",
    neutral_yellow = "#f0c674",
    neutral_blue = "#81a2be",
    neutral_purple = "#b294bb",
    neutral_aqua = "#8abeb7",
    neutral_orange = "#de935f",

    -- Diff & special dark shades
    dark_red = "#5c363d",
    dark_green = "#545b3b",
    dark_aqua = "#3e585a",

    -- Convenience / component-specific aliases
    light2 = "#eaeaea",
    bright_red = "#d54e53",
    bright_green = "#b9ca4a",
    bright_yellow = "#e7c547",
    bright_blue = "#7aa6da",
    bright_purple = "#c397d8",
    bright_aqua = "#70c0b1",
    bright_orange = "#de935f",
  },
  light = {
    -- Backgrounds & light shades
    bg_dark = "#f2f2f2",
    bg_buffer = "#ffffff",
    bg0 = "#ffffff",
    bg1 = "#f0f0f1",
    bg2 = "#e1e1e3",
    bg3 = "#c7c8ca",
    bg4 = "#adafb2",

    -- Foregrounds & dark shades
    fg0 = "#1d1f21",
    fg1 = "#282c34",
    fg2 = "#4d4d4c",
    fg3 = "#666666",
    fg4 = "#808080",

    -- Accent colors (Tomorrow day variants of the Ghostty palette)
    red = "#c82829",
    green = "#718c00",
    yellow = "#c99e00",
    blue = "#4271ae",
    purple = "#8959a8",
    aqua = "#3e999f",
    orange = "#f5871f",
    gray = "#8e908c",
    pink = "#c8454a",

    -- Neutral tones
    neutral_red = "#cc6666",
    neutral_green = "#b5bd68",
    neutral_yellow = "#f0c674",
    neutral_blue = "#81a2be",
    neutral_purple = "#b294bb",
    neutral_aqua = "#8abeb7",
    neutral_orange = "#de935f",

    -- Diff & special light shades
    dark_red = "#f1c9ca",
    dark_green = "#dce2bf",
    dark_aqua = "#cfe6e7",

    -- Convenience / component-specific aliases
    light2 = "#e1e1e3",
    bright_red = "#c82829",
    bright_green = "#718c00",
    bright_yellow = "#c99e00",
    bright_blue = "#4271ae",
    bright_purple = "#8959a8",
    bright_aqua = "#3e999f",
    bright_orange = "#f5871f",
  },
}

return M
