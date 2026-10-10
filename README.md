<div align="center">
  <h1>gruvbox_v2.nvim</h1>
  <p>A modernized, high-contrast Gruvbox for Neovim with darkened floating windows, smart buffer-only transparency, and git-reactive file trees.</p>
</div>

---

### ✨ Why gruvbox_v2?

- 🌑 **Darkened Floats & Sidebars (`#141617`)** — Floating windows, pickers, completion popups, and sidebars use a dedicated dark background for instant visual hierarchy against the `#1d2021` buffer.
- 🪟 **Buffer-Only Transparency (`transparent = true`)** — Only your editor buffer becomes transparent; popups, pickers, and sidebar panels maintain their solid dark backdrop so they never bleed into your terminal.
- 📂 **Git-Reactive File Trees** — Directories default to crisp cyan (`#8ec07c`), with git-diffed files styled in **italic** (staged = green italic, unstaged = yellow italic, untracked = aqua italic). Works out of the box with Snacks, Neo-tree, Nvim-tree, and Diffview.
- 🎨 **Zero-Config Lualine** — Automatically discovers and styles `gruvbox_v2` for both dark and light modes.

---

### 📦 Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "Codesmith28/gruvbox_v2.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    contrast = "hard",     -- "hard" (default), "soft", or ""
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

Customize palette colors or override any highlight group with ease:

```lua
require("gruvbox_v2").setup({
  contrast = "hard",
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
