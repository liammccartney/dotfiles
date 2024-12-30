-- Temporary work around for Treesitter bug
-- https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

require("config.lazy")

vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- Keystrokes to re-source a lua file or just execute some lines
vim.keymap.set("n", "<space><space>x", "<CMD>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
