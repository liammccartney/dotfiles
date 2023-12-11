-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

-- Save files
map("n", "<leader>w", ":up<CR>")
map("n", "<leader>W", ":wa!<CR>")

-- Snap search results to middle of page
map("n", "n", "nzz")
map("n", "N", "Nzz")

-- Toggle between buffers
map("n", "<leader><leader>", "<c-^>")

-- Split vertically quickly
map("n", "<leader>vs", ":vsplit<CR>")

-- Clear search highlights
map("n", "<leader><CR>", ":noh<CR>")

-- Close all open location lists, or w/e they're called
-- that get opend by other plugins
map("n", "<leader>cc", ":cclose<cr> :pclose<cr> :lclose<cr>")

-- Make split navigation easy
map("n", "<UP>", "<C-o>")
map("n", "<Down>", "<C-i>")
map("n", "<Left>", ":bprev<CR>")
map("n", "<Right>", ":bnext<CR>")
