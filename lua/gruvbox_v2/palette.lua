--- Re-export base palette and colors for backwards compatibility
local colors = require("gruvbox_v2.colors")

return setmetatable(colors.base, {
  __index = function(_, key)
    if colors[key] then
      return colors[key]
    end
  end,
})
