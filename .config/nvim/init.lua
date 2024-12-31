-- Temporary work around for Treesitter bug
-- https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

local g = vim.g

g.mapleader = ","

local function map(m, k, v, opts)
  opts = opts or {}
  opts["silent"] = true
  vim.keymap.set(m, k, v, opts)
end

-- Move between splits with <c-hjkl>
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-h>", "<c-w>h")
map("n", "<c-l>", "<c-w>l")

-- Snap search results to middle of page
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Save files
map("n", "<leader>w", ":up<CR>", { desc = "Save Current File" })
map("n", "<leader>W", ":wa!<CR>", { desc = "Save All Files" })

-- Toggle between buffers
map("n", "<leader><leader>", "<c-^>", { desc = "Toggle Between Buffers" })

-- Split vertically quickly
map("n", "<leader>vs", ":vsplit<CR>", { desc = "Open Vertical Split" })

-- Clear search highlights
map("n", "<leader><CR>", ":noh<CR>", { desc = "Clear Search Highlights" })

-- Close all open location lists, or w/e they're called
-- that get opened by other plugins
map("n", "<leader>cc", ":cclose<cr> :pclose<cr> :lclose<cr>", { desc = "Close all loc and quickfix lists" })

-- Jump list Navigation
map("n", "<UP>", "<C-o>")
map("n", "<Down>", "<C-i>")
map("n", "<Left>", ":bprev<CR>")
map("n", "<Right>", ":bnext<CR>")

vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- Keystrokes to re-source a lua file or just execute some lines
map("n", "<space><space>x", "<CMD>source %<CR>")
map("n", "<space>x", ":.lua<CR>")
map("v", "<space>x", ":lua<CR>")

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

require("config.lazy")
