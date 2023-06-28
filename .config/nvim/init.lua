require("neodev").setup()
require("core.options")
require("core.keymaps")
--
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- auto install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  print('Installing lazy.nvim')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
  print('Done')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {'folke/tokyonight.nvim'},
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'}, 
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     
      {'hrsh7th/cmp-nvim-lsp'}, 
      {'L3MON4D3/LuaSnip'},    
    }
  },
  { "folke/neodev.nvim", opts = {} }
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
