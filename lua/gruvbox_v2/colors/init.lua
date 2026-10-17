--- Gruvbox v2 Colors Module
--- Provides modular palettes across the 3 contrast modes: hard, regular, and soft.

local M = {}

M.hard = require("gruvbox_v2.colors.hard")
M.regular = require("gruvbox_v2.colors.regular")
M.soft = require("gruvbox_v2.colors.soft")
M.base = require("gruvbox_v2.colors.base")

--- Normalize contrast string to one of the 3 supported contrasts
---@param contrast string? "regular" | "hard" | "soft" | "" | "medium"
---@return "regular" | "hard" | "soft"
function M.normalize_contrast(contrast)
  if contrast == "soft" then
    return "soft"
  elseif contrast == "regular" or contrast == "medium" or contrast == "" then
    return "regular"
  else
    return "hard"
  end
end

--- Get palette for given contrast and background mode
---@param contrast string? "regular" | "hard" | "soft"
---@param background string? "dark" | "light"
---@param overrides table<string, string>?
---@return table<string, string>
function M.get(contrast, background, overrides)
  local c = M.normalize_contrast(contrast)
  local bg = background or vim.o.background or "dark"
  if bg ~= "light" then
    bg = "dark"
  end

  local contrast_def = M[c] or M.hard
  local colors = vim.deepcopy(contrast_def[bg] or contrast_def.dark)

  if overrides then
    for k, v in pairs(overrides) do
      colors[k] = v
      -- Legacy Gruvbox palette key mappings
      if k == "dark0_hard" and c == "hard" and bg == "dark" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k == "dark0" and c == "regular" and bg == "dark" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k == "dark0_soft" and c == "soft" and bg == "dark" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k == "light0_hard" and c == "hard" and bg == "light" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k == "light0" and c == "regular" and bg == "light" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k == "light0_soft" and c == "soft" and bg == "light" then
        colors.bg0 = v
        colors.bg_buffer = v
      elseif k:match("^bright_") and bg == "dark" then
        colors[k:sub(8)] = v
      elseif k:match("^faded_") and bg == "light" then
        colors[k:sub(7)] = v
      end
    end
  end

  return colors
end

return M
