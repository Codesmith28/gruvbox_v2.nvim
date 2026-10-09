<div align="center">
      <h1>gruvbox_v2.nvim</h1>
      <p>A modernized, enhanced fork of Gruvbox for Neovim with deep contrast, darkened floating windows & sidebars, refined visual highlights, and extensive plugin support.</p>
</div>

<p align="center"> 
      <a href="#"><img alt="Made with Lua" src="https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua" style="vertical-align:center" /></a>
</p>

## ✨ What's new in v2

- **Darkened Floating Windows & Dialogs (`#141617`)**: Floats, pickers, completion popups, and sidebars use a dedicated dark background for crisp visual hierarchy against the `#1d2021` buffer.
- **Default Hard Contrast**: Buffer backgrounds default to Gruvbox Dark Hard (`#1d2021`), matching terminal themes like Ghostty, Alacritty, and Kitty.
- **Softened Visual Selection**: Replaced the harsh visual selection with a softened `#504945` background for better legibility.
- **Unified Terminal ANSI Colors**: ANSI black (`terminal_color_0`) matches the darker background `#141617` out of the box.
- **Native Lualine Theme**: Built-in Lualine themes (`theme = "auto"` or `"gruvbox_v2"`) that adapt seamlessly to both dark and light modes.
- **Buffer-Only Transparency (`transparent = true`)**: Only the code buffer becomes transparent while sidebars, dialogs, pickers, and popups preserve their solid `#141617` background.
- **Explorer Git Diff Highlights**: Files with diffs in Snacks, Neo-tree, and Nvim-tree feature italic styling (staged = green italic, unstaged = yellow italic, untracked = aqua italic, deleted = red italic).
- **Universal Plugin Ecosystem**: First-class, out-of-the-box styling for:
  - **Pickers**: Telescope, Fzf-lua, Snacks.picker, Mini.pick
  - **Completion**: Blink.cmp, nvim-cmp
  - **Sidebars & Explorers**: Snacks explorer, Neo-tree, Nvim-tree, Outline, Aerial, Trouble (v3)
  - **Tablines & Buffers**: Bufferline.nvim, Mini.tabline
  - **UI / Popups**: Which-key (v3), Lazy, Mason, Noice, Flash.nvim, Mini.nvim (mini.files, mini.clue, etc.)
  - **Indent & Markdown**: Snacks.indent, Indent-blankline (ibl v3), Render-markdown.nvim, Treesitter-context
  - **Git**: Gitsigns, Diffview, Neogit, Mini.diff
- **Dual Naming Support**: Use `:colorscheme gruvbox_v2` or `:colorscheme gruvbox`, `require("gruvbox_v2")` or `require("gruvbox")`.

---

## 📦 Installation

### Using `lazy.nvim`

```lua
{
  "Codesmith28/gruvbox_v2.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- optional custom configuration
  },
  config = function(_, opts)
    require("gruvbox").setup(opts)
    vim.cmd.colorscheme("gruvbox_v2")
  end,
}
```

### Using `vim.pack` (Neovim 0.12+ / native pack)

```lua
vim.pack.add({
  "https://github.com/Codesmith28/gruvbox_v2.nvim"
})

require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox_v2")
```

### Using `packer.nvim`

```lua
use {
  "Codesmith28/gruvbox_v2.nvim",
  config = function()
    require("gruvbox").setup()
    vim.cmd.colorscheme("gruvbox_v2")
  end,
}
```

### Using `vim-plug`

```vim
Plug 'Codesmith28/gruvbox_v2.nvim'

" In init.lua / init.vim
lua require('gruvbox').setup()
colorscheme gruvbox_v2
```

---

## 🚀 Basic Usage

Inside `init.lua`:

```lua
vim.o.background = "dark" -- or "light" for light mode
vim.cmd.colorscheme("gruvbox_v2")
```

Inside `init.vim`:

```vim
set background=dark " or light
colorscheme gruvbox_v2
```

---

## ⚙️ Configuration

All settings are optional. Below are the defaults:

```lua
require("gruvbox").setup({
  terminal_colors = true, -- map terminal colors to gruvbox palette
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true,
  contrast = "hard", -- default in v2: "hard", can be "soft" or ""
  palette_overrides = {
    -- e.g. bg_dark = "#101213",
  },
  overrides = {
    -- custom highlight overrides
  },
  dim_inactive = false,
  transparent_mode = false, -- or transparent = true (makes only the buffer transparent, keeping sidebars and floats solid dark)
})

vim.cmd.colorscheme("gruvbox_v2")
```

> **Note**: Call `setup()` before `colorscheme gruvbox_v2` to apply custom configurations.

### 🪟 Transparent Background (Buffer Only)

When `transparent_mode = true` (or `transparent = true`), **only the editor buffer** (`Normal`, `NormalNC`, `SignColumn`, `FoldColumn`, `LineNr`, `CursorLineNr`, `Folded`, `WinBar`) is made transparent. Sidebars (`NormalSB`, Neo-tree, Nvim-tree), floating windows (`NormalFloat`, `FloatBorder`), pickers (Telescope, Snacks.picker, Fzf-lua), intellisense menus (Blink.cmp, nvim-cmp), and statusline retain their solid dark background (`#141617`) so they never bleed into your terminal or wallpaper.

---

### 📂 Explorer Git Diff Highlights (Snacks, Neo-tree, Nvim-tree)

Files with git changes in sidebars and file explorers feature distinct colors and **italic text** for rapid visual parsing:

| File Status | Color | Font Style | Highlight Groups |
| :--- | :--- | :--- | :--- |
| **Default File** | Standard FG (`#ebdbb2`) | Normal | `NeoTreeFileName`, `SnacksPickerGitStatus`, `NvimTreeFileName` |
| **Staged / Added** | Green (`#b8bb26`) | **Italic** | `SnacksPickerGitStatusStaged`, `NeoTreeGitStaged`, `NvimTreeGitStaged` |
| **Unstaged / Modified** | Yellow (`#fabd2f`) | **Italic** | `SnacksPickerGitStatusModified`, `NeoTreeGitModified`, `NvimTreeGitDirty` |
| **Untracked / New** | Aqua (`#8ec07c`) | **Italic** | `SnacksPickerGitStatusUntracked`, `NeoTreeGitUntracked`, `NvimTreeGitNew` |
| **Deleted** | Red (`#fb4934`) | **Italic** | `SnacksPickerGitStatusDeleted`, `NeoTreeGitDeleted`, `NvimTreeGitDeleted` |
| **Conflict / Unmerged** | Orange (`#fe8019`) | **Bold Italic** | `SnacksPickerGitStatusUnmerged`, `NeoTreeGitConflict`, `NvimTreeGitMerge` |
| **Renamed / Copied** | Purple (`#d3869b`) | **Italic** | `SnacksPickerGitStatusRenamed`, `NeoTreeGitRenamed`, `NvimTreeGitRenamed` |
| **Ignored** | Muted Gray (`#928374`)| Normal | `SnacksPickerGitStatusIgnored`, `NeoTreeGitIgnored`, `NvimTreeGitIgnored` |

---

## 🎨 Statusline & Tabline Integration

### Lualine (`lualine.nvim`)

`gruvbox_v2.nvim` provides first-class Lualine themes out of the box via `lua/lualine/themes/gruvbox_v2.lua` and `lua/lualine/themes/gruvbox.lua`.

**Zero configuration required!** Since Lualine defaults to `options.theme = "auto"`, it automatically discovers and loads `gruvbox_v2`. It also includes native styling for `normal`, `insert`, `visual`, `replace`, `command`, `terminal`, and `inactive` modes in both dark and light modes:

```lua
-- No lualine configuration is needed!
-- If you do configure lualine options, you can use:
require("lualine").setup({
  options = {
    theme = "auto", -- Automatically picks up gruvbox_v2
  },
})
```

### Bufferline (`bufferline.nvim`)

Native highlights are provided for `bufferline.nvim`. The tabline bar uses the dedicated darkened panel background (`#141617`), while the active buffer tab connects seamlessly to the main buffer with a yellow accent indicator.

---

## ⚡ LazyVim Integration

`gruvbox_v2.nvim` works out-of-the-box with LazyVim without requiring any custom theme functions, picker options, or statusline workarounds:

```lua
-- In lua/plugins/theme.lua
return {
  {
    "Codesmith28/gruvbox_v2.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      contrast = "hard",
      transparent = true, -- Buffer-only transparency
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox_v2",
    },
  },
}
```

---

## 🔌 Extended Plugin Support

`gruvbox_v2.nvim` includes handcrafted, comprehensive styling for:

- **LSP & Diagnostics (Neovim 0.10+)**: Full semantic tokens (`@lsp.*`), `DiagnosticUnnecessary` (dead code / unused imports), `LspInlayHint`, `DiagnosticDeprecated` (strikethrough), `LspReference*`, and `LspCodeLens`.
- **Pickers**: `snacks.picker`, `telescope.nvim`, `fzf-lua`, `mini.pick`.
- **Sidebars & File Trees**: `snacks.picker.explorer`, `neo-tree.nvim`, `nvim-tree.lua`, `outline.nvim`, `aerial.nvim`, `trouble.nvim` (v3).
- **Completion & Intellisense**: `blink.cmp`, `nvim-cmp`, `coc.nvim`.
- **Motions & Enhancements**: `flash.nvim`, `which-key.nvim` (v3), `noice.nvim`.
- **Indent & Structure**: `snacks.indent`, `indent-blankline.nvim` (ibl v3), `nvim-treesitter-context`, `mini.indentscope`.
- **Markdown & Documents**: `render-markdown.nvim`, modern treesitter `@markup.*`.
- **Git**: `gitsigns.nvim` (including blame & inline diffs), `diffview.nvim` (file panel & diffs), `neogit`, `mini.diff`.
- **UI & Tools**: `lazy.nvim`, `mason.nvim`, `snacks.notifier`, `nvim-notify`, `nvim-dap-ui`, `mini.nvim` suite.

---

## 🛠️ Overrides

### Custom Palette

```lua
require("gruvbox").setup({
  palette_overrides = {
    bright_green = "#990000",
    bg_dark = "#101213", -- customize sidebar & floating panel background
  },
})
vim.cmd.colorscheme("gruvbox_v2")
```

### Custom Highlights

```lua
require("gruvbox").setup({
  overrides = {
    SignColumn = { bg = "#ff9900" },
    ["@lsp.type.method"] = { bg = "#ff9900" },
    ["@comment.lua"] = { italic = true },
  },
})
vim.cmd.colorscheme("gruvbox_v2")
```

---

## 🧪 Running Tests

Unit tests use [plenary.nvim](https://github.com/nvim-lua/plenary.nvim):

```bash
make test
```
