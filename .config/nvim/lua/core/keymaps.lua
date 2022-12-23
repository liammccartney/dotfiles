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

map('n', 'n', 'nzz');
map('n', 'N', 'Nzz');

map('n', '<leader>w', ':up<CR>')
map('n', '<leader>W', ':wa!<CR>')

map('n', '<leader><leader>', '<c-^>')

map('n', '<leader>vs', ':vsplit<CR>')

map('n', '<leader><CR>', ':noh<CR>')
map('n', '<leader>cc', ':cclose<cr> :pclose<cr> :lclose<cr>')

map('n', '<UP>', '<C-o>')
map('n', '<Down>', '<C-i>')
map('n', '<Left>', ':bprev<CR>')
map('n', '<Right>', ':bnext<CR>')

map('n', '<leader>nn', ':NERDTreeToggle<CR>')
map('n', '<leader>nm', ':NERDTreeFind<CR>')

map('n', '<C-f>', '<cmd>Telescope find_files<cr>')
map('n', '<C-b>', '<cmd>Telescope buffers<cr>')
map('n', '<leader>g', '<cmd>Telescope live_grep<cr>')

map('n', '<leader>t', ':TestNearest<cr>')
map('n', '<leader>T', ':TestFile<cr>')
map('n', '<leader>tl', ':TestLast<cr>')
