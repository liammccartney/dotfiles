local g = vim.g

g.mapleader = ','

local function map(m, k, v)
  vim.keymap.set(m, k, v, { silent = true })
end

-- Move between splits with <c-hjkl>
map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-h>', '<c-w>h')
map('n', '<c-l>', '<c-w>l')

-- Snap search results to middle of page
map('n', 'n', 'nzz');
map('n', 'N', 'Nzz');

-- Save files
map('n', '<leader>w', ':up<CR>')
map('n', '<leader>W', ':wa!<CR>')

-- Toggle between buffers
map('n', '<leader><leader>', '<c-^>')

-- Split vertically quickly
map('n', '<leader>vs', ':vsplit<CR>')

-- Clear search highlights
map('n', '<leader><CR>', ':noh<CR>')

-- Close all open location lists, or w/e they're called
-- that get opend by other plugins
map('n', '<leader>cc', ':cclose<cr> :pclose<cr> :lclose<cr>')

-- Make split navigation easy
map('n', '<UP>', '<C-o>')
map('n', '<Down>', '<C-i>')
map('n', '<Left>', ':bprev<CR>')
map('n', '<Right>', ':bnext<CR>')

map('n', '<leader>rr', ':so ~/.config/nvim/init.lua<cr>')
