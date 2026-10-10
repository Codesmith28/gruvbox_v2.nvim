require("plenary.reload").reload_module("gruvbox_v2", true)
local gruvbox = require("gruvbox_v2")
local default = gruvbox.config

local function clear_term_colors()
  for item = 0, 15 do
    vim.g["terminal_color_" .. item] = nil
  end
end

describe("tests", function()
  it("works with default values", function()
    gruvbox.setup()
    assert.are.same(gruvbox.config, default)
  end)

  it("works with config overrides", function()
    local expected = {
      terminal_colors = true,
      undercurl = false,
      underline = false,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      inverse = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      contrast = "hard",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    }

    gruvbox.setup({ undercurl = false, underline = false })
    assert.are.same(gruvbox.config, expected)
  end)

  it("should override a hightlight color", function()
    local config = {
      overrides = {
        Search = { fg = "#ff9900", bg = "#000000" },
        ColorColumn = { bg = "#ff9900" },
      },
    }

    gruvbox.setup(config)
    gruvbox.load()

    local search_group_id = vim.api.nvim_get_hl_id_by_name("Search")
    local search_values = {
      background = vim.fn.synIDattr(search_group_id, "bg", "gui"),
      foreground = vim.fn.synIDattr(search_group_id, "fg", "gui"),
    }

    assert.are.same(search_values, { background = "#000000", foreground = "#ff9900" })

    local color_column_group_id = vim.api.nvim_get_hl_id_by_name("ColorColumn")
    local color_column_values = {
      background = vim.fn.synIDattr(color_column_group_id, "bg", "gui"),
    }

    assert.are.same(color_column_values, { background = "#ff9900" })
  end)

  it("should create new hightlights colors if they dont exist", function()
    local config = {
      overrides = {
        Search = { fg = "#ff9900", bg = "#000000" },
        New = { bg = "#ff9900" },
      },
    }

    gruvbox.setup(config)
    gruvbox.load()

    local search_group_id = vim.api.nvim_get_hl_id_by_name("Search")
    local search_values = {
      background = vim.fn.synIDattr(search_group_id, "bg", "gui"),
      foreground = vim.fn.synIDattr(search_group_id, "fg", "gui"),
    }

    assert.are.same(search_values, { background = "#000000", foreground = "#ff9900" })

    local new_group_id = vim.api.nvim_get_hl_id_by_name("New")
    local new_group_values = {
      background = vim.fn.synIDattr(new_group_id, "bg", "gui"),
    }

    assert.are.same(new_group_values, { background = "#ff9900" })
  end)

  it("should override links", function()
    local config = {
      overrides = {
        TelescopePreviewBorder = { fg = "#990000", bg = nil },
      },
    }
    gruvbox.setup(config)
    gruvbox.load()

    local group_id = vim.api.nvim_get_hl_id_by_name("TelescopePreviewBorder")
    local values = {
      fg = vim.fn.synIDattr(group_id, "fg", "gui"),
    }

    local expected = {
      fg = "#990000",
    }
    assert.are.same(expected, values)
  end)

  it("should override palette", function()
    local config = {
      palette_overrides = {
        gray = "#ff9900",
      },
    }

    gruvbox.setup(config)
    gruvbox.load()

    local group_id = vim.api.nvim_get_hl_id_by_name("Comment")
    local values = {
      fg = vim.fn.synIDattr(group_id, "fg", "gui"),
    }
    assert.are.same(values, { fg = "#ff9900" })
  end)

  it("does not set terminal colors when terminal_colors is false", function()
    clear_term_colors()
    gruvbox.setup({ terminal_colors = false })
    gruvbox.load()
    assert.is_nil(vim.g.terminal_color_0)
  end)

  it("sets terminal colors when terminal_colors is true", function()
    clear_term_colors()
    gruvbox.setup({ terminal_colors = true })
    gruvbox.load()

    -- dark bg
    local colors = require("gruvbox_v2").palette
    vim.opt.background = "dark"
    assert.are.same(vim.g.terminal_color_0, colors.bg_dark or "#141617")

    -- light bg
    clear_term_colors()
    gruvbox.load()
    vim.opt.background = "light"
    assert.are.same(vim.g.terminal_color_0, colors.light0_hard)
  end)

  it("multiple calls to setup() are independent", function()
    -- First call to setup
    gruvbox.setup({
      contrast = "soft",
      overrides = { CursorLine = { bg = "#FF0000" } },
    })
    assert.are.same(gruvbox.config.contrast, "soft")
    assert.are.same(gruvbox.config.overrides.CursorLine.bg, "#FF0000")

    -- Second call to setup
    gruvbox.setup({ contrast = "hard" })
    assert.are.same(gruvbox.config.contrast, "hard")
    -- Check that overrides from the first call are not present
    assert.is_nil(gruvbox.config.overrides.CursorLine)

    -- Third call to setup with different overrides
    gruvbox.setup({
      overrides = { Normal = { fg = "#00FF00" } },
    })
    assert.are.same(gruvbox.config.contrast, "hard") -- Contrast should be reset to default (hard)
    assert.is_nil(gruvbox.config.overrides.CursorLine) -- Still no CursorLine override
    assert.are.same(gruvbox.config.overrides.Normal.fg, "#00FF00") -- New override is present

    -- Call setup with no arguments to reset to defaults
    gruvbox.setup()
    assert.are.same(gruvbox.config.contrast, "hard")
    assert.is_nil(gruvbox.config.overrides.Normal)
  end)

  it("sets custom gruvbox_v2 highlights out of the box", function()
    vim.opt.background = "dark"
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local float_id = vim.api.nvim_get_hl_id_by_name("NormalFloat")
    local float_bg = vim.fn.synIDattr(float_id, "bg", "gui")
    assert.are.same(float_bg, "#141617")

    local border_id = vim.api.nvim_get_hl_id_by_name("FloatBorder")
    local border_bg = vim.fn.synIDattr(border_id, "bg", "gui")
    assert.are.same(border_bg, "#141617")

    local visual_id = vim.api.nvim_get_hl_id_by_name("Visual")
    local visual_bg = vim.fn.synIDattr(visual_id, "bg", "gui")
    assert.are.same(visual_bg, "#504945")

    local pmenu_id = vim.api.nvim_get_hl_id_by_name("Pmenu")
    local pmenu_bg = vim.fn.synIDattr(vim.fn.synIDtrans(pmenu_id), "bg", "gui")
    assert.are.same(pmenu_bg, "#141617")

    local float_plugins = {
      "TelescopeNormal",
      "FzfLuaNormal",
      "BlinkCmpMenu",
      "CmpDocumentation",
      "WhichKeyNormal",
      "LazyNormal",
      "MasonNormal",
    }
    for _, group in ipairs(float_plugins) do
      local id = vim.api.nvim_get_hl_id_by_name(group)
      local bg = vim.fn.synIDattr(vim.fn.synIDtrans(id), "bg", "gui")
      assert.are.same(bg, "#141617")
    end

    local sidebar_plugins = {
      "NeoTreeNormal",
      "NvimTreeNormal",
      "OutlineNormal",
      "AerialNormal",
      "TroubleNormal",
    }
    for _, group in ipairs(sidebar_plugins) do
      local id = vim.api.nvim_get_hl_id_by_name(group)
      local bg = vim.fn.synIDattr(vim.fn.synIDtrans(id), "bg", "gui")
      assert.are.same(bg, "#141617")
    end

    assert.are.same(vim.g.colors_name, "gruvbox_v2")
  end)

  it("provides lualine theme and snacks opts", function()
    vim.opt.background = "dark"
    local theme = gruvbox.lualine_theme
    assert.is_not_nil(theme)
    assert.is_not_nil(theme.normal)
    assert.are.same(theme.normal.c.bg, "#141617")
    assert.are.same(theme.normal.a.fg, "#1d2021")

    -- Test light mode adaptability
    vim.opt.background = "light"
    local light_theme = gruvbox.get_lualine_theme()
    assert.is_not_nil(light_theme)
    assert.are.same(light_theme.normal.c.bg, "#ebdbb2")
    vim.opt.background = "dark"

    assert.is_not_nil(gruvbox.snacks_opts)
    assert.is_not_nil(gruvbox.snacks_opts.picker.sources.explorer)
  end)

  it("supports transparent mode for buffer only while preserving dark sidebars and floats", function()
    vim.opt.background = "dark"
    gruvbox.setup({ transparent_mode = true })
    gruvbox.load("gruvbox_v2")

    -- Buffer highlights must be transparent
    local normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    local normal_bg = vim.fn.synIDattr(normal_id, "bg", "gui")
    assert.are.same(normal_bg, "")

    local sign_id = vim.api.nvim_get_hl_id_by_name("SignColumn")
    local sign_bg = vim.fn.synIDattr(sign_id, "bg", "gui")
    assert.are.same(sign_bg, "")

    local fold_id = vim.api.nvim_get_hl_id_by_name("FoldColumn")
    local fold_bg = vim.fn.synIDattr(fold_id, "bg", "gui")
    assert.are.same(fold_bg, "")

    local cursor_ln_id = vim.api.nvim_get_hl_id_by_name("CursorLineNr")
    local cursor_ln_bg = vim.fn.synIDattr(cursor_ln_id, "bg", "gui")
    assert.are.same(cursor_ln_bg, "")

    -- Sidebars, floats, pickers, and statusline must RETAIN solid dark background
    local float_id = vim.api.nvim_get_hl_id_by_name("NormalFloat")
    local float_bg = vim.fn.synIDattr(float_id, "bg", "gui")
    assert.are.same(float_bg, "#141617")

    local sb_id = vim.api.nvim_get_hl_id_by_name("NormalSB")
    local sb_bg = vim.fn.synIDattr(sb_id, "bg", "gui")
    assert.are.same(sb_bg, "#141617")

    local status_id = vim.api.nvim_get_hl_id_by_name("StatusLine")
    local status_bg = vim.fn.synIDattr(status_id, "bg", "gui")
    assert.are.same(status_bg, "#141617")

    local pmenu_id = vim.api.nvim_get_hl_id_by_name("Pmenu")
    local pmenu_bg = vim.fn.synIDattr(vim.fn.synIDtrans(pmenu_id), "bg", "gui")
    assert.are.same(pmenu_bg, "#141617")

    local picker_id = vim.api.nvim_get_hl_id_by_name("SnacksPickerBox")
    local picker_bg = vim.fn.synIDattr(picker_id, "bg", "gui")
    assert.are.same(picker_bg, "#141617")
  end)

  it("supports transparent = true as an alias for transparent_mode", function()
    gruvbox.setup({ transparent = true })
    assert.is_true(gruvbox.config.transparent_mode)
  end)

  it("provides lualine theme modules on runtimepath for auto discovery", function()
    local theme_v2 = require("lualine.themes.gruvbox_v2")
    assert.is_not_nil(theme_v2)
    assert.is_not_nil(theme_v2.normal)
    assert.are.same(theme_v2.normal.c.bg, "#141617")
    assert.is_not_nil(theme_v2.terminal)
    assert.are.same(theme_v2.terminal.c.bg, "#141617")
  end)

  it("provides modern Neovim ecosystem highlights (LSP, Snacks, Flash, Ibl, Noice)", function()
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local inlay_id = vim.api.nvim_get_hl_id_by_name("LspInlayHint")
    assert.are.same(vim.fn.synIDattr(inlay_id, "italic", "gui"), "1")

    local unnec_id = vim.api.nvim_get_hl_id_by_name("DiagnosticUnnecessary")
    assert.are.same(vim.fn.synIDattr(unnec_id, "italic", "gui"), "1")

    local flash_id = vim.api.nvim_get_hl_id_by_name("FlashLabel")
    assert.are.same(vim.fn.synIDattr(flash_id, "bold", "gui"), "1")

    local ibl_id = vim.api.nvim_get_hl_id_by_name("IblIndent")
    assert.is_not_nil(vim.fn.synIDattr(ibl_id, "fg", "gui"))

    local noice_id = vim.api.nvim_get_hl_id_by_name("NoicePopup")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(noice_id), "bg", "gui"), "#141617")
  end)

  it("styles diffed files in explorers (Snacks, NeoTree, NvimTree) as italic with green staged and yellow unstaged", function()
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local palette = gruvbox.palette
    local green = palette.bright_green or "#b8bb26"
    local yellow = palette.bright_yellow or "#fabd2f"
    local aqua = palette.bright_aqua or "#8ec07c"
    local red = palette.bright_red or "#fb4934"
    local purple = palette.bright_purple or "#d3869b"
    local orange = palette.bright_orange or "#fe8019"

    -- Default Directory is cyan
    local dir_id = vim.api.nvim_get_hl_id_by_name("Directory")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(dir_id), "fg", "gui"), aqua)

    -- Snacks Picker / Explorer
    local snacks_dir = vim.api.nvim_get_hl_id_by_name("SnacksPickerDirectory")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(snacks_dir), "fg", "gui"), aqua)
    local snacks_path_dir = vim.api.nvim_get_hl_id_by_name("SnacksPickerDir")
    assert.are.same(vim.fn.synIDattr(snacks_path_dir, "fg", "gui"), aqua)

    local snacks_staged = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusStaged")
    assert.are.same(vim.fn.synIDattr(snacks_staged, "fg", "gui"), green)
    assert.are.same(vim.fn.synIDattr(snacks_staged, "italic", "gui"), "1")

    local snacks_mod = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusModified")
    assert.are.same(vim.fn.synIDattr(snacks_mod, "fg", "gui"), yellow)
    assert.are.same(vim.fn.synIDattr(snacks_mod, "italic", "gui"), "1")

    local snacks_untracked = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusUntracked")
    assert.are.same(vim.fn.synIDattr(snacks_untracked, "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(snacks_untracked, "italic", "gui"), "1")

    local snacks_deleted = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusDeleted")
    assert.are.same(vim.fn.synIDattr(snacks_deleted, "fg", "gui"), red)
    assert.are.same(vim.fn.synIDattr(snacks_deleted, "italic", "gui"), "1")

    -- NeoTree
    local neotree_dirname = vim.api.nvim_get_hl_id_by_name("NeoTreeDirectoryName")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_dirname), "fg", "gui"), aqua)
    local neotree_diricon = vim.api.nvim_get_hl_id_by_name("NeoTreeDirectoryIcon")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_diricon), "fg", "gui"), aqua)

    local neotree_staged = vim.api.nvim_get_hl_id_by_name("NeoTreeGitStaged")
    assert.are.same(vim.fn.synIDattr(neotree_staged, "fg", "gui"), green)
    assert.are.same(vim.fn.synIDattr(neotree_staged, "italic", "gui"), "1")

    local neotree_mod = vim.api.nvim_get_hl_id_by_name("NeoTreeGitModified")
    assert.are.same(vim.fn.synIDattr(neotree_mod, "fg", "gui"), yellow)
    assert.are.same(vim.fn.synIDattr(neotree_mod, "italic", "gui"), "1")

    local neotree_untracked = vim.api.nvim_get_hl_id_by_name("NeoTreeGitUntracked")
    assert.are.same(vim.fn.synIDattr(neotree_untracked, "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(neotree_untracked, "italic", "gui"), "1")

    -- NvimTree
    local nvimtree_foldericon = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderIcon")
    assert.are.same(vim.fn.synIDattr(nvimtree_foldericon, "fg", "gui"), aqua)
    local nvimtree_foldername = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderName")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_foldername), "fg", "gui"), aqua)

    local nvimtree_staged = vim.api.nvim_get_hl_id_by_name("NvimTreeGitStaged")
    assert.are.same(vim.fn.synIDattr(nvimtree_staged, "fg", "gui"), green)
    assert.are.same(vim.fn.synIDattr(nvimtree_staged, "italic", "gui"), "1")

    local nvimtree_dirty = vim.api.nvim_get_hl_id_by_name("NvimTreeGitDirty")
    assert.are.same(vim.fn.synIDattr(nvimtree_dirty, "fg", "gui"), yellow)
    assert.are.same(vim.fn.synIDattr(nvimtree_dirty, "italic", "gui"), "1")

    local nvimtree_new = vim.api.nvim_get_hl_id_by_name("NvimTreeGitNew")
    assert.are.same(vim.fn.synIDattr(nvimtree_new, "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(nvimtree_new, "italic", "gui"), "1")

    -- diffFile
    local diff_file = vim.api.nvim_get_hl_id_by_name("diffFile")
    assert.are.same(vim.fn.synIDattr(diff_file, "italic", "gui"), "1")
  end)

  it("integrates with BufferLine, TreesitterContext, RenderMarkdown, and Diffview", function()
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    -- BufferLine
    local buf_fill = vim.api.nvim_get_hl_id_by_name("BufferLineFill")
    assert.are.same(vim.fn.synIDattr(buf_fill, "bg", "gui"), "#141617")

    -- TreesitterContext
    local ts_ctx = vim.api.nvim_get_hl_id_by_name("TreesitterContext")
    assert.is_not_nil(vim.fn.synIDattr(ts_ctx, "bg", "gui"))

    -- RenderMarkdown
    local md_h1 = vim.api.nvim_get_hl_id_by_name("RenderMarkdownH1")
    assert.are.same(vim.fn.synIDattr(md_h1, "bold", "gui"), "1")

    -- Diffview
    local dv_mod = vim.api.nvim_get_hl_id_by_name("DiffviewStatusModified")
    assert.are.same(vim.fn.synIDattr(dv_mod, "italic", "gui"), "1")
  end)
end)
