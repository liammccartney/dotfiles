vim.pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } ,
  { src = "https://github.com/nvim-mini/mini.nvim", name = "mini" } ,
  { src = "https://github.com/neovim/nvim-lspconfig", name = "nvim-lspconfig" } ,
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", name = "nvim-treesitter", version = 'main' } ,
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp'
}

local cmp = require('blink.cmp')
cmp.build():wait(60000)
cmp.setup()

vim.cmd.colorscheme("catppuccin-nvim")

-- Key mappings
vim.g.mapleader = ","      -- Set leader key to comma
vim.g.maplocalleader = "," -- Set local leader key

-- Save files
vim.keymap.set("n", "<leader>w", ":up<CR>", { desc = "Save Current File" })
vim.keymap.set("n", "<leader>W", ":wa!<CR>", { desc = "Save All Files" })

-- Toggle between buffers
vim.keymap.set("n", "<leader><leader>", "<c-^>", { desc = "Toggle Between Buffers" })

-- Clear search highlights
vim.keymap.set("n", "<leader><CR>", ":noh<CR>", { desc = "Clear Search Highlights" })

vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion options

-- Jump list Navigation
vim.keymap.set("n", "<UP>", "<C-o>")
vim.keymap.set("n", "<Down>", "<C-i>")
vim.keymap.set("n", "<Left>", ":bprev<CR>")
vim.keymap.set("n", "<Right>", ":bnext<CR>")

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

require('mini.basics').setup()
require('mini.surround').setup()

vim.lsp.enable({ 'lua_ls' })
vim.lsp.enable({ 'ts_ls' })
vim.lsp.enable({ 'ts_ls' })
vim.lsp.enable('csharp_ls')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    map('n', 'gr', vim.lsp.buf.references, 'Go to references')
    map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
    map('n', 'gy', vim.lsp.buf.type_definition, 'Go to type definition')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('n', '<leader>ds', vim.lsp.buf.document_symbol, 'Document symbols')
    map('n', '<leader>ws', vim.lsp.buf.workspace_symbol, 'Workspace symbols')
    map('n', '[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
    map('n', ']d', vim.diagnostic.goto_next, 'Next diagnostic')
    map('n', '<leader>e', vim.diagnostic.open_float, 'Show diagnostic')
  end,
})
