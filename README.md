<div align="center">
  <h1>gruvbox_v2.nvim</h1>
  <p>A modernized, high-contrast Gruvbox for Neovim with darkened floating windows, smart buffer-only transparency, and git-reactive file trees.</p>
</div>

---

### ✨ Why gruvbox_v2?

- 🌑 **Darkened Floats & Sidebars (`#141617`)** — Floating windows, pickers, completion popups, and sidebars use a dedicated dark background for instant visual hierarchy against the `#1d2021` buffer.
- 🪟 **Buffer-Only Transparency (`transparent = true`)** — Only your editor buffer becomes transparent; popups, pickers, and sidebar panels maintain their solid dark backdrop so they never bleed into your terminal.
- 📑 **Consistent Tab Bar & Icon Backgrounds** — Tab bars (`bufferline.nvim`, `barbar.nvim`, `mini.tabline`, native `TabLine`) keep buffer and file icons (`mini.icons`, `nvim-web-devicons`) perfectly seamless with their enclosing active and inactive tabs in both transparent and non-transparent modes.
- 📂 **Git-Reactive File Trees & Signs (Catppuccin Style)** — Unstaged modified files and hunks appear in crisp yellow, staged files in green, untracked in subtle gray, deleted in red, and staged hunks automatically dimmed in GitSigns. Works seamlessly across Snacks Explorer, GitSigns, Neo-tree, Nvim-tree, Diffview, and Neovim standard diffs.
- 🎨 **Zero-Config Lualine & BufferLine** — Automatically discovers and styles `gruvbox_v2` for both dark and light modes, with first-class `get_bufferline_theme()` support.
- 🚨 **Distinct Error Squiggles & Diagnostics** — Syntax errors and LSP diagnostics stand out cleanly from surrounding syntax with bright red foreground, bold styling, and native red error squiggles (`undercurl = true, sp = red`) with reliable terminal underline fallback.

---

### 📦 Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Codesmith28/gruvbox_v2.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    contrast = "hard",     -- "hard" (default), "regular", or "soft"
    transparent = false,   -- set to true for buffer-only transparency
  },
  config = function(_, opts)
    require("gruvbox_v2").setup(opts)
    vim.cmd.colorscheme("gruvbox_v2")
  end,
}
```

---

### ⚙️ Customization

#### Contrasts
Choose from 3 distinct contrast modes:
- `"regular"` — The original classic Gruvbox contrast (`#282828` buffer) with dimmed floats & sidebars (`#1d2021`).
- `"hard"` (default) — Deep dark high-contrast Gruvbox (`#1d2021` buffer, `#141617` floats/sidebars).
- `"soft"` — Warm, gentle Gruvbox (`#32302f` buffer, `#282828` floats/sidebars).

#### Modular Color Architecture
All color definitions are cleanly separated into dedicated contrast files for easy tinkering:
- [`lua/gruvbox_v2/colors/regular.lua`](lua/gruvbox_v2/colors/regular.lua)
- [`lua/gruvbox_v2/colors/hard.lua`](lua/gruvbox_v2/colors/hard.lua)
- [`lua/gruvbox_v2/colors/soft.lua`](lua/gruvbox_v2/colors/soft.lua)

Customize palette colors or override any highlight group with ease:

```lua
require("gruvbox_v2").setup({
  contrast = "regular", -- "regular", "hard", or "soft"
  transparent = true,
  palette_overrides = {
    bg_dark = "#101213", -- custom float / sidebar background
  },
  overrides = {
    Directory = { fg = "#8ec07c", bold = true },
    Comment = { italic = true },
  },
})
vim.cmd.colorscheme("gruvbox_v2")
```

---

### 🔌 Ecosystem Support

Handcrafted, out-of-the-box styling for modern Neovim:

**Snacks** • **Blink.cmp** • **Telescope** • **Neo-tree** • **Nvim-tree** • **Trouble** • **Diffview** • **BufferLine** • **Which-key** • **Noice** • **Flash** • **Render-Markdown** • **Treesitter Context** • **Mini.nvim**
