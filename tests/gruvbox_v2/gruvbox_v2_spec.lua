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

  it("styles directories and files wrt git status (Snacks, NeoTree, NvimTree, MiniFiles) following Catppuccin scheme", function()
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local palette = gruvbox.palette
    local green = palette.bright_green or "#b8bb26"
    local yellow = palette.bright_yellow or "#fabd2f"
    local aqua = palette.bright_aqua or "#8ec07c"
    local red = palette.bright_red or "#fb4934"
    local purple = palette.bright_purple or "#d3869b"
    local orange = palette.bright_orange or "#fe8019"
    local gray = palette.gray or "#928374"
    local blue = palette.bright_blue or "#83a598"

    -- Standard Neovim diff groups
    local added_id = vim.api.nvim_get_hl_id_by_name("Added")
    assert.are.same(vim.fn.synIDattr(added_id, "fg", "gui"), green)
    local changed_id = vim.api.nvim_get_hl_id_by_name("Changed")
    assert.are.same(vim.fn.synIDattr(changed_id, "fg", "gui"), yellow)
    local removed_id = vim.api.nvim_get_hl_id_by_name("Removed")
    assert.are.same(vim.fn.synIDattr(removed_id, "fg", "gui"), red)

    local diff_added = vim.api.nvim_get_hl_id_by_name("diffAdded")
    assert.are.same(vim.fn.synIDattr(diff_added, "fg", "gui"), green)
    local diff_changed = vim.api.nvim_get_hl_id_by_name("diffChanged")
    assert.are.same(vim.fn.synIDattr(diff_changed, "fg", "gui"), yellow)
    local diff_removed = vim.api.nvim_get_hl_id_by_name("diffRemoved")
    assert.are.same(vim.fn.synIDattr(diff_removed, "fg", "gui"), red)

    -- GitSigns highlights
    local gs_add = vim.api.nvim_get_hl_id_by_name("GitSignsAdd")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(gs_add), "fg", "gui"), green)
    local gs_change = vim.api.nvim_get_hl_id_by_name("GitSignsChange")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(gs_change), "fg", "gui"), yellow)
    local gs_delete = vim.api.nvim_get_hl_id_by_name("GitSignsDelete")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(gs_delete), "fg", "gui"), red)

    -- Default Directory is cyan and unbold
    local dir_id = vim.api.nvim_get_hl_id_by_name("Directory")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(dir_id), "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(dir_id), "bold", "gui"), "")

    -- Snacks Picker / Explorer
    local snacks_dir = vim.api.nvim_get_hl_id_by_name("SnacksPickerDirectory")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(snacks_dir), "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(snacks_dir), "bold", "gui"), "")
    local snacks_path_dir = vim.api.nvim_get_hl_id_by_name("SnacksPickerDir")
    assert.are.same(vim.fn.synIDattr(snacks_path_dir, "fg", "gui"), aqua)
    local snacks_file = vim.api.nvim_get_hl_id_by_name("SnacksPickerFile")
    assert.is_not_nil(vim.fn.synIDattr(snacks_file, "fg", "gui"))

    local snacks_staged = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusStaged")
    assert.are.same(vim.fn.synIDattr(snacks_staged, "fg", "gui"), green)

    local snacks_added = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusAdded")
    assert.are.same(vim.fn.synIDattr(snacks_added, "fg", "gui"), green)

    local snacks_mod = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusModified")
    assert.are.same(vim.fn.synIDattr(snacks_mod, "fg", "gui"), yellow)

    local snacks_unstaged = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusUnstaged")
    assert.are.same(vim.fn.synIDattr(snacks_unstaged, "fg", "gui"), yellow)

    local snacks_untracked = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusUntracked")
    assert.are.same(vim.fn.synIDattr(snacks_untracked, "fg", "gui"), gray)

    local snacks_deleted = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusDeleted")
    assert.are.same(vim.fn.synIDattr(snacks_deleted, "fg", "gui"), red)

    local snacks_unmerged = vim.api.nvim_get_hl_id_by_name("SnacksPickerGitStatusUnmerged")
    assert.are.same(vim.fn.synIDattr(snacks_unmerged, "fg", "gui"), red)
    assert.are.same(vim.fn.synIDattr(snacks_unmerged, "bold", "gui"), "1")

    assert.is_true(gruvbox.snacks_opts.picker.sources.explorer.git_status_open)

    -- NeoTree
    local neotree_dirname = vim.api.nvim_get_hl_id_by_name("NeoTreeDirectoryName")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_dirname), "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_dirname), "bold", "gui"), "")
    local neotree_diricon = vim.api.nvim_get_hl_id_by_name("NeoTreeDirectoryIcon")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_diricon), "fg", "gui"), aqua)
    local neotree_root = vim.api.nvim_get_hl_id_by_name("NeoTreeRootName")
    assert.are.same(vim.fn.synIDattr(neotree_root, "bold", "gui"), "1")

    local neotree_staged = vim.api.nvim_get_hl_id_by_name("NeoTreeGitStaged")
    assert.are.same(vim.fn.synIDattr(neotree_staged, "fg", "gui"), green)

    local neotree_folder_staged = vim.api.nvim_get_hl_id_by_name("NeoTreeFolderStaged")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_folder_staged), "fg", "gui"), green)

    local neotree_mod = vim.api.nvim_get_hl_id_by_name("NeoTreeGitModified")
    assert.are.same(vim.fn.synIDattr(neotree_mod, "fg", "gui"), yellow)

    local neotree_folder_dirty = vim.api.nvim_get_hl_id_by_name("NeoTreeFolderDirty")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(neotree_folder_dirty), "fg", "gui"), yellow)

    local neotree_unstaged = vim.api.nvim_get_hl_id_by_name("NeoTreeGitUnstaged")
    assert.are.same(vim.fn.synIDattr(neotree_unstaged, "fg", "gui"), yellow)

    local neotree_untracked = vim.api.nvim_get_hl_id_by_name("NeoTreeGitUntracked")
    assert.are.same(vim.fn.synIDattr(neotree_untracked, "fg", "gui"), purple)

    -- NvimTree
    local nvimtree_foldericon = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderIcon")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_foldericon), "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_foldericon), "bold", "gui"), "")
    local nvimtree_foldername = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderName")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_foldername), "fg", "gui"), aqua)
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_foldername), "bold", "gui"), "")
    local nvimtree_openedfolder = vim.api.nvim_get_hl_id_by_name("NvimTreeOpenedFolderName")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_openedfolder), "bold", "gui"), "")
    local nvimtree_root = vim.api.nvim_get_hl_id_by_name("NvimTreeRootFolder")
    assert.are.same(vim.fn.synIDattr(nvimtree_root, "bold", "gui"), "1")

    local nvimtree_staged = vim.api.nvim_get_hl_id_by_name("NvimTreeGitStaged")
    assert.are.same(vim.fn.synIDattr(nvimtree_staged, "fg", "gui"), green)

    local nvimtree_folder_staged = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderStaged")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_folder_staged), "fg", "gui"), green)

    local nvimtree_dirty = vim.api.nvim_get_hl_id_by_name("NvimTreeGitDirty")
    assert.are.same(vim.fn.synIDattr(nvimtree_dirty, "fg", "gui"), yellow)

    local nvimtree_folder_dirty = vim.api.nvim_get_hl_id_by_name("NvimTreeFolderDirty")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(nvimtree_folder_dirty), "fg", "gui"), yellow)

    local nvimtree_new = vim.api.nvim_get_hl_id_by_name("NvimTreeGitNew")
    assert.are.same(vim.fn.synIDattr(nvimtree_new, "fg", "gui"), blue)

    -- MiniFiles
    local minifiles_dir_mod = vim.api.nvim_get_hl_id_by_name("MiniFilesDirectoryModified")
    assert.are.same(vim.fn.synIDattr(minifiles_dir_mod, "fg", "gui"), yellow)

    local minifiles_dir_staged = vim.api.nvim_get_hl_id_by_name("MiniFilesDirectoryStaged")
    assert.are.same(vim.fn.synIDattr(minifiles_dir_staged, "fg", "gui"), green)

    local minifiles_file_mod = vim.api.nvim_get_hl_id_by_name("MiniFilesFileModified")
    assert.are.same(vim.fn.synIDattr(minifiles_file_mod, "fg", "gui"), yellow)

    local minifiles_file_staged = vim.api.nvim_get_hl_id_by_name("MiniFilesFileStaged")
    assert.are.same(vim.fn.synIDattr(minifiles_file_staged, "fg", "gui"), green)

    local minifiles_file_untracked = vim.api.nvim_get_hl_id_by_name("MiniFilesFileUntracked")
    assert.are.same(vim.fn.synIDattr(minifiles_file_untracked, "fg", "gui"), gray)
  end)

  it("integrates with BufferLine, TreesitterContext, RenderMarkdown, and Diffview", function()
    gruvbox.setup({ transparent = false })
    gruvbox.load("gruvbox_v2")

    -- BufferLine
    local buf_fill = vim.api.nvim_get_hl_id_by_name("BufferLineFill")
    assert.are.same(vim.fn.synIDattr(buf_fill, "bg", "gui"), "#141617")

    local buf_bg = vim.api.nvim_get_hl_id_by_name("BufferLineBackground")
    assert.are.same(vim.fn.synIDattr(buf_bg, "bg", "gui"), "#141617")

    local buf_vis = vim.api.nvim_get_hl_id_by_name("BufferLineBufferVisible")
    assert.are.same(vim.fn.synIDattr(buf_vis, "bg", "gui"), "#141617")

    local buf_sel = vim.api.nvim_get_hl_id_by_name("BufferLineBufferSelected")
    assert.are.same(vim.fn.synIDattr(buf_sel, "bg", "gui"), "#1d2021")

    -- TreesitterContext
    local ts_ctx = vim.api.nvim_get_hl_id_by_name("TreesitterContext")
    assert.is_not_nil(vim.fn.synIDattr(ts_ctx, "bg", "gui"))

    -- RenderMarkdown
    local md_h1 = vim.api.nvim_get_hl_id_by_name("RenderMarkdownH1")
    assert.are.same(vim.fn.synIDattr(md_h1, "bold", "gui"), "1")

    -- Diffview
    local dv_mod = vim.api.nvim_get_hl_id_by_name("DiffviewStatusModified")
    assert.are.same(vim.fn.synIDattr(dv_mod, "fg", "gui"), "#fabd2f")
  end)

  it("ensures consistent background coloring for tabs and tab icons across BufferLine, Barbar, TabLine, and MiniTabline", function()
    -- 1. Non-transparent mode
    gruvbox.setup({ transparent = false })
    gruvbox.load("gruvbox_v2")

    -- BufferLine theme generator
    local bl_theme_fn = gruvbox.get_bufferline_theme()
    assert.is_function(bl_theme_fn)
    local bl_theme = bl_theme_fn()
    assert.are.same(bl_theme.background.bg, "#141617")
    assert.are.same(bl_theme.buffer_visible.bg, "#141617")
    assert.are.same(bl_theme.fill.bg, "#141617")
    assert.are.same(bl_theme.buffer_selected.bg, "#1d2021")

    -- metatable accessor
    assert.is_function(gruvbox.bufferline_theme)

    -- Mock existing devicons and mini.icons before sync
    vim.api.nvim_set_hl(0, "BufferLineDevIconLua", { fg = 0x83a598, bg = nil })
    vim.api.nvim_set_hl(0, "BufferLineDevIconLuaSelected", { fg = 0x83a598, bg = nil })
    vim.api.nvim_set_hl(0, "BufferLineMiniIconsAzure", { fg = 0x83a598, bg = nil })
    vim.api.nvim_set_hl(0, "BufferLineMiniIconsYellowSelected", { fg = 0xfabd2f, bg = nil })

    gruvbox.sync_bufferline()

    local inact_icon = vim.api.nvim_get_hl(0, { name = "BufferLineDevIconLua" })
    local sel_icon = vim.api.nvim_get_hl(0, { name = "BufferLineDevIconLuaSelected" })
    local mini_inact_icon = vim.api.nvim_get_hl(0, { name = "BufferLineMiniIconsAzure" })
    local mini_sel_icon = vim.api.nvim_get_hl(0, { name = "BufferLineMiniIconsYellowSelected" })

    local function hex_col(val)
      if not val then return nil end
      return string.format("#%06x", val)
    end

    assert.are.same(hex_col(inact_icon.bg), "#141617")
    assert.are.same(hex_col(mini_inact_icon.bg), "#141617")
    assert.are.same(hex_col(sel_icon.bg), "#1d2021")
    assert.are.same(hex_col(mini_sel_icon.bg), "#1d2021")

    -- 2. Transparent mode
    gruvbox.setup({ transparent = true })
    gruvbox.load("gruvbox_v2")

    vim.api.nvim_set_hl(0, "BufferLineDevIconLua", { fg = 0x83a598, bg = nil })
    vim.api.nvim_set_hl(0, "BufferLineDevIconLuaSelected", { fg = 0x83a598, bg = 0x1d2021 })
    gruvbox.sync_bufferline()

    local sel_tab_t = vim.api.nvim_get_hl(0, { name = "BufferLineBufferSelected" })
    assert.is_nil(sel_tab_t.bg)

    local inact_icon_t = vim.api.nvim_get_hl(0, { name = "BufferLineDevIconLua" })
    local sel_icon_t = vim.api.nvim_get_hl(0, { name = "BufferLineDevIconLuaSelected" })
    assert.are.same(hex_col(inact_icon_t.bg), "#141617")
    assert.is_nil(sel_icon_t.bg)

    -- 3. Barbar highlights consistency
    local barb_curr = vim.api.nvim_get_hl(0, { name = "BufferCurrent" })
    local barb_curr_icon = vim.api.nvim_get_hl(0, { name = "BufferCurrentIcon" })
    assert.are.same(barb_curr.bg, barb_curr_icon.bg)

    local barb_vis = vim.api.nvim_get_hl(0, { name = "BufferVisible" })
    local barb_vis_icon = vim.api.nvim_get_hl(0, { name = "BufferVisibleIcon" })
    assert.are.same(hex_col(barb_vis.bg), "#141617")
    assert.are.same(hex_col(barb_vis_icon.bg), "#141617")

    local barb_inact = vim.api.nvim_get_hl(0, { name = "BufferInactive" })
    local barb_inact_icon = vim.api.nvim_get_hl(0, { name = "BufferInactiveIcon" })
    assert.are.same(hex_col(barb_inact.bg), "#141617")
    assert.are.same(hex_col(barb_inact_icon.bg), "#141617")

    -- 4. TabLine and MiniTabline consistency
    local tab_fill = vim.api.nvim_get_hl(0, { name = "TabLineFill" })
    assert.are.same(hex_col(tab_fill.bg), "#141617")

    local mini_hidden = vim.api.nvim_get_hl(0, { name = "MiniTablineHidden" })
    assert.are.same(hex_col(mini_hidden.bg), "#141617")

    local mini_vis = vim.api.nvim_get_hl(0, { name = "MiniTablineVisible" })
    assert.are.same(hex_col(mini_vis.bg), "#141617")
  end)

  it("styles word under cursor highlights subtly like Catppuccin with zero external dependencies", function()
    vim.opt.background = "dark"
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local text_id = vim.api.nvim_get_hl_id_by_name("LspReferenceText")
    assert.are.same(vim.fn.synIDattr(text_id, "bg", "gui"), "#504945")
    assert.are.same(vim.fn.synIDattr(text_id, "fg", "gui"), "")

    local read_id = vim.api.nvim_get_hl_id_by_name("LspReferenceRead")
    assert.are.same(vim.fn.synIDattr(read_id, "bg", "gui"), "#504945")
    assert.are.same(vim.fn.synIDattr(read_id, "fg", "gui"), "")

    local write_id = vim.api.nvim_get_hl_id_by_name("LspReferenceWrite")
    assert.are.same(vim.fn.synIDattr(write_id, "bg", "gui"), "#504945")
    assert.are.same(vim.fn.synIDattr(write_id, "underline", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(write_id, "sp", "gui"), "#fe8019")

    -- vim-illuminate, mini.cursorword, and cursorword links
    local ill_text = vim.api.nvim_get_hl_id_by_name("IlluminatedWordText")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(ill_text), "bg", "gui"), "#504945")

    local mini_cw = vim.api.nvim_get_hl_id_by_name("MiniCursorword")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(mini_cw), "bg", "gui"), "#504945")

    local cw = vim.api.nvim_get_hl_id_by_name("CursorWord")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(cw), "bg", "gui"), "#504945")
  end)

  it("styles functions as cyan and unbold", function()
    vim.opt.background = "dark"
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local func_id = vim.api.nvim_get_hl_id_by_name("Function")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(func_id), "fg", "gui"), "#8ec07c")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(func_id), "bold", "gui"), "")

    local at_func_id = vim.api.nvim_get_hl_id_by_name("@function")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(at_func_id), "fg", "gui"), "#8ec07c")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(at_func_id), "bold", "gui"), "")
  end)

  it("styles errors distinctly with red foreground, bold, and red error squiggles (undercurl)", function()
    gruvbox.setup()
    gruvbox.load("gruvbox_v2")

    local err_id = vim.api.nvim_get_hl_id_by_name("Error")
    assert.are.same(vim.fn.synIDattr(err_id, "fg", "gui"), "#fb4934")
    assert.are.same(vim.fn.synIDattr(err_id, "bold", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(err_id, "undercurl", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(err_id, "sp", "gui"), "#fb4934")
    assert.are.same(vim.fn.synIDattr(err_id, "reverse", "gui"), "")
    assert.are.same(vim.fn.synIDattr(err_id, "bg", "gui"), "")

    local at_err_id = vim.api.nvim_get_hl_id_by_name("@error")
    assert.are.same(vim.fn.synIDattr(at_err_id, "fg", "gui"), "#fb4934")
    assert.are.same(vim.fn.synIDattr(at_err_id, "undercurl", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(at_err_id, "sp", "gui"), "#fb4934")

    local at_err_bracket = vim.api.nvim_get_hl_id_by_name("@error.bracket")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(at_err_bracket), "fg", "gui"), "#fb4934")

    local at_err_delim = vim.api.nvim_get_hl_id_by_name("@error.delimiter")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(at_err_delim), "fg", "gui"), "#fb4934")

    local diag_err_id = vim.api.nvim_get_hl_id_by_name("DiagnosticUnderlineError")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(diag_err_id), "undercurl", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(vim.fn.synIDtrans(diag_err_id), "sp", "gui"), "#fb4934")

    -- build.gradle tasks.register should not have reverse or red background
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "build.gradle")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      "tasks.register('generateDelcoConfig', Exec) {}"
    })
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("filetype detect")
    vim.cmd("syntax on")

    local syn_id = vim.fn.synID(1, 8, 1)
    local syn_trans = vim.fn.synIDtrans(syn_id)
    assert.are.same(vim.fn.synIDattr(syn_trans, "reverse", "gui"), "")
    assert.are.same(vim.fn.synIDattr(syn_trans, "bg", "gui"), "")
    assert.are.same(vim.fn.synIDattr(syn_trans, "undercurl", "gui"), "1")
    assert.are.same(vim.fn.synIDattr(syn_trans, "sp", "gui"), "#fb4934")
  end)

  it("supports regular contrast with original medium Gruvbox background and dimmed sidebars", function()
    -- 1. Dark mode
    vim.opt.background = "dark"
    gruvbox.setup({ contrast = "regular" })
    gruvbox.load("gruvbox_v2")

    assert.are.same(gruvbox.config.contrast, "regular")

    local normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    local normal_bg = vim.fn.synIDattr(normal_id, "bg", "gui")
    assert.are.same(normal_bg, "#282828") -- original medium Gruvbox dark background

    local float_id = vim.api.nvim_get_hl_id_by_name("NormalFloat")
    local float_bg = vim.fn.synIDattr(float_id, "bg", "gui")
    assert.are.same(float_bg, "#1d2021") -- dimmed sidebar / float background for regular contrast

    local sb_id = vim.api.nvim_get_hl_id_by_name("NormalSB")
    local sb_bg = vim.fn.synIDattr(sb_id, "bg", "gui")
    assert.are.same(sb_bg, "#1d2021")

    local pmenu_id = vim.api.nvim_get_hl_id_by_name("Pmenu")
    local pmenu_bg = vim.fn.synIDattr(vim.fn.synIDtrans(pmenu_id), "bg", "gui")
    assert.are.same(pmenu_bg, "#1d2021")

    local status_id = vim.api.nvim_get_hl_id_by_name("StatusLine")
    local status_bg = vim.fn.synIDattr(status_id, "bg", "gui")
    assert.are.same(status_bg, "#1d2021")

    -- Diff colors for regular contrast
    local diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(diff_del, "bg", "gui"), "#722529")
    local diff_add = vim.api.nvim_get_hl_id_by_name("DiffAdd")
    assert.are.same(vim.fn.synIDattr(diff_add, "bg", "gui"), "#62693e")
    local diff_chg = vim.api.nvim_get_hl_id_by_name("DiffChange")
    assert.are.same(vim.fn.synIDattr(diff_chg, "bg", "gui"), "#49503b")

    -- Lualine theme adapts to regular contrast
    local theme = gruvbox.get_lualine_theme()
    assert.are.same(theme.normal.a.fg, "#282828")
    assert.are.same(theme.normal.c.bg, "#1d2021")

    -- BufferLine theme adapts to regular contrast
    local bl_theme = gruvbox.get_bufferline_theme()()
    assert.are.same(bl_theme.buffer_selected.bg, "#282828")
    assert.are.same(bl_theme.fill.bg, "#1d2021")

    -- 2. Light mode
    vim.opt.background = "light"
    gruvbox.setup({ contrast = "regular" })
    gruvbox.load("gruvbox_v2")

    local light_normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    local light_normal_bg = vim.fn.synIDattr(light_normal_id, "bg", "gui")
    assert.are.same(light_normal_bg, "#fbf1c7") -- original medium Gruvbox light background

    local light_diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(light_diff_del, "bg", "gui"), "#fc9487")

    local light_theme = gruvbox.get_lualine_theme()
    assert.are.same(light_theme.normal.a.fg, "#fbf1c7")

    vim.opt.background = "dark"
  end)

  it("supports soft contrast with warmer background and dimmed sidebars", function()
    -- 1. Dark mode
    vim.opt.background = "dark"
    gruvbox.setup({ contrast = "soft" })
    gruvbox.load("gruvbox_v2")

    assert.are.same(gruvbox.config.contrast, "soft")

    local normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    local normal_bg = vim.fn.synIDattr(normal_id, "bg", "gui")
    assert.are.same(normal_bg, "#32302f") -- soft Gruvbox dark background

    local float_id = vim.api.nvim_get_hl_id_by_name("NormalFloat")
    local float_bg = vim.fn.synIDattr(float_id, "bg", "gui")
    assert.are.same(float_bg, "#282828") -- dimmed sidebar / float background for soft contrast

    -- Diff colors for soft contrast
    local diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(diff_del, "bg", "gui"), "#7b2c2f")
    local diff_add = vim.api.nvim_get_hl_id_by_name("DiffAdd")
    assert.are.same(vim.fn.synIDattr(diff_add, "bg", "gui"), "#686d43")

    -- 2. Light mode
    vim.opt.background = "light"
    gruvbox.setup({ contrast = "soft" })
    gruvbox.load("gruvbox_v2")

    local light_normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    assert.are.same(vim.fn.synIDattr(light_normal_id, "bg", "gui"), "#f2e5bc")

    local light_diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(light_diff_del, "bg", "gui"), "#f78b7f")

    vim.opt.background = "dark"
  end)

  it("supports hard contrast with deepest background and darkest sidebars", function()
    -- 1. Dark mode
    vim.opt.background = "dark"
    gruvbox.setup({ contrast = "hard" })
    gruvbox.load("gruvbox_v2")

    assert.are.same(gruvbox.config.contrast, "hard")

    local normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    assert.are.same(vim.fn.synIDattr(normal_id, "bg", "gui"), "#1d2021")

    local float_id = vim.api.nvim_get_hl_id_by_name("NormalFloat")
    assert.are.same(vim.fn.synIDattr(float_id, "bg", "gui"), "#141617")

    local diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(diff_del, "bg", "gui"), "#792329")

    -- 2. Light mode
    vim.opt.background = "light"
    gruvbox.setup({ contrast = "hard" })
    gruvbox.load("gruvbox_v2")

    local light_normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    assert.are.same(vim.fn.synIDattr(light_normal_id, "bg", "gui"), "#f9f5d7")

    local light_diff_del = vim.api.nvim_get_hl_id_by_name("DiffDelete")
    assert.are.same(vim.fn.synIDattr(light_diff_del, "bg", "gui"), "#fc9690")

    vim.opt.background = "dark"
  end)

  it("handles contrast aliases 'medium' and empty string '' as regular", function()
    vim.opt.background = "dark"

    gruvbox.setup({ contrast = "medium" })
    gruvbox.load("gruvbox_v2")
    local normal_id = vim.api.nvim_get_hl_id_by_name("Normal")
    assert.are.same(vim.fn.synIDattr(normal_id, "bg", "gui"), "#282828")

    gruvbox.setup({ contrast = "" })
    gruvbox.load("gruvbox_v2")
    local normal_id2 = vim.api.nvim_get_hl_id_by_name("Normal")
    assert.are.same(vim.fn.synIDattr(normal_id2, "bg", "gui"), "#282828")
  end)

  it("exports modular color files for direct tinkering (regular, hard, soft)", function()
    local hard_mod = require("gruvbox_v2.colors.hard")
    assert.is_table(hard_mod.dark)
    assert.is_table(hard_mod.light)
    assert.are.same(hard_mod.dark.bg0, "#1d2021")
    assert.are.same(hard_mod.dark.bg_dark, "#141617")

    local regular_mod = require("gruvbox_v2.colors.regular")
    assert.is_table(regular_mod.dark)
    assert.is_table(regular_mod.light)
    assert.are.same(regular_mod.dark.bg0, "#282828")
    assert.are.same(regular_mod.dark.bg_dark, "#1d2021")

    local soft_mod = require("gruvbox_v2.colors.soft")
    assert.is_table(soft_mod.dark)
    assert.is_table(soft_mod.light)
    assert.are.same(soft_mod.dark.bg0, "#32302f")
    assert.are.same(soft_mod.dark.bg_dark, "#282828")
  end)
end)
