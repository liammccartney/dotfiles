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
  {
    "folke/neodev.nvim",
    opts = {}
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('duskfox')
    end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' },
      {
        'williamboman/mason.nvim',
        build = function()
          pcall(function() vim.cmd('MasonUpdate') end)
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    }
  },
  {
    "folke/neodev.nvim",
    opts = {}
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim'
    }
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  },
  { 'onsails/lspkind.nvim' },
  {
    "numToStr/Comment.nvim",
    config = function()
      require('Comment').setup()
    end
  },
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-abolish' },
  { 'tpope/vim-surround' },
  { 'lewis6991/gitsigns.nvim' },
})

require("plugins.lsp")
require("plugins.cmp")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.nvim-tree")
