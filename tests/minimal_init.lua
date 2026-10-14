local plenary_dir = os.getenv("PLENARY_DIR")
  or (vim.fn.isdirectory(vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim")) == 1 and vim.fn.expand("~/.local/share/nvim/lazy/plenary.nvim"))
  or "/tmp/plenary.nvim"
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
  vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", plenary_dir })
end

vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)

vim.cmd("runtime plugin/plenary.vim")
require("plenary.busted")
