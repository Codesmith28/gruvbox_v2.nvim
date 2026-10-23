--- Catppuccin-inspired syntax highlighting for Ghostty mode.
--- Reassigns which palette color each syntax group uses; UI groups are left untouched.

---@param colors table<string, string> resolved palette
---@param config GruvboxConfig
---@return table<string, HighlightDefinition>
return function(colors, config)
  local c = colors
  local comment = { fg = c.gray, italic = config.italic.comments }
  local keyword = { fg = c.purple }
  local func = { fg = c.blue }
  local const = { fg = c.orange }
  local str = { fg = c.green, italic = config.italic.strings }
  local type_ = { fg = c.yellow }
  local punct = { fg = c.fg4 }
  local param = { fg = c.pink }
  local prop = { fg = c.aqua }
  local link = { fg = c.blue, underline = config.underline }

  return {
    -- Vim syntax groups
    Comment = comment,
    Statement = keyword,
    Conditional = keyword,
    Repeat = keyword,
    Label = keyword,
    Exception = keyword,
    Keyword = keyword,
    Operator = { fg = c.neutral_aqua, italic = config.italic.operators },
    Identifier = { fg = c.fg1 },
    Function = func,
    PreProc = type_,
    Include = keyword,
    Define = keyword,
    Macro = keyword,
    Constant = const,
    String = str,
    Character = { fg = c.aqua },
    Boolean = const,
    Number = const,
    Float = const,
    Type = type_,
    Typedef = type_,
    Structure = type_,
    StorageClass = keyword,
    Special = { fg = c.neutral_purple },
    SpecialChar = { fg = c.neutral_purple },
    Tag = func,
    Delimiter = punct,
    Title = { fg = c.blue, bold = config.bold },
    Underlined = link,

    -- Treesitter
    ["@comment"] = comment,
    ["@operator"] = { fg = c.neutral_aqua, italic = config.italic.operators },
    ["@punctuation"] = punct,
    ["@punctuation.delimiter"] = punct,
    ["@punctuation.bracket"] = punct,
    ["@punctuation.special"] = { fg = c.neutral_aqua },
    ["@string"] = str,
    ["@string.regex"] = { fg = c.orange, italic = config.italic.strings },
    ["@string.regexp"] = { fg = c.orange, italic = config.italic.strings },
    ["@string.escape"] = { fg = c.neutral_purple },
    ["@string.special"] = { fg = c.neutral_purple },
    ["@string.special.symbol"] = { fg = c.pink },
    ["@string.special.path"] = link,
    ["@string.special.url"] = link,
    ["@character"] = { fg = c.aqua },
    ["@character.special"] = { fg = c.neutral_purple },
    ["@boolean"] = const,
    ["@number"] = const,
    ["@number.float"] = const,
    ["@float"] = const,
    ["@function"] = func,
    ["@function.call"] = func,
    ["@function.method"] = func,
    ["@function.method.call"] = func,
    ["@method"] = func,
    ["@method.call"] = func,
    ["@function.builtin"] = { fg = c.orange },
    ["@function.macro"] = keyword,
    ["@constructor"] = { fg = c.neutral_blue },
    ["@parameter"] = param,
    ["@variable.parameter"] = param,
    ["@keyword"] = keyword,
    ["@keyword.function"] = keyword,
    ["@keyword.return"] = keyword,
    ["@keyword.operator"] = keyword,
    ["@keyword.conditional"] = keyword,
    ["@keyword.repeat"] = keyword,
    ["@keyword.exception"] = keyword,
    ["@keyword.import"] = keyword,
    ["@keyword.storage"] = keyword,
    ["@keyword.directive"] = type_,
    ["@keyword.directive.define"] = keyword,
    ["@conditional"] = keyword,
    ["@repeat"] = keyword,
    ["@exception"] = keyword,
    ["@include"] = keyword,
    ["@label"] = keyword,
    ["@storageclass"] = keyword,
    ["@preproc"] = type_,
    ["@define"] = keyword,
    ["@macro"] = keyword,
    ["@type"] = type_,
    ["@type.builtin"] = type_,
    ["@type.definition"] = type_,
    ["@type.qualifier"] = keyword,
    ["@structure"] = type_,
    ["@attribute"] = type_,
    ["@field"] = prop,
    ["@property"] = prop,
    ["@variable.member"] = prop,
    ["@variable"] = { fg = c.fg1 },
    ["@variable.builtin"] = { fg = c.pink },
    ["@symbol"] = { fg = c.pink },
    ["@constant"] = const,
    ["@constant.builtin"] = const,
    ["@constant.macro"] = const,
    ["@module"] = { fg = c.neutral_blue },
    ["@namespace"] = { fg = c.neutral_blue },
    ["@tag"] = func,
    ["@tag.attribute"] = prop,
    ["@tag.delimiter"] = punct,

    -- Markup
    ["@markup.heading"] = { fg = c.blue, bold = config.bold },
    ["@markup.raw"] = { fg = c.green },
    ["@markup.link"] = link,
    ["@markup.link.label"] = { fg = c.blue },
    ["@markup.list"] = { fg = c.neutral_aqua },
    ["@text.title"] = { fg = c.blue, bold = config.bold },
    ["@text.literal"] = { fg = c.green },
    ["@text.uri"] = link,
    ["@text.reference"] = const,
  }
end
