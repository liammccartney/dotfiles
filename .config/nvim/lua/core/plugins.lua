local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Package Manager
  use 'wbthomason/packer.nvim'
  -- Colorscheme(s)
  use 'EdenEast/nightfox.nvim'
  -- File Tree Navigator
  use 'nvim-tree/nvim-tree.lua'
  -- Nice Icons for File Tree
  use 'nvim-tree/nvim-web-devicons'
  -- Nicer Status Line
  use 'nvim-lualine/lualine.nvim'
  -- Syntax Highlighting and other semantic awareness for neovim
  use 'nvim-treesitter/nvim-treesitter'
  -- Fuzzy Finder for all the things
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Sort of a package manager for Language Servers that integrates
  -- into neovim's lsp feature
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  -- Report LSP start up progress
  use 'arkav/lualine-lsp-progress'
  -- Use telescope for lsp Code Actions
  use 'nvim-telescope/telescope-ui-select.nvim'
  -- Add Context Line at top of screen
  use {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig"
  }

  -- Autocompletion
  --   Note: I don't understand why I need three packages here yet
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use "L3MON4D3/LuaSnip"

  -- Comment Toggler
  use 'numToStr/Comment.nvim'

  -- Formatting (LSP Formatter doesn't use prettier in TS/HTML/CSS land)
  use 'sbdchd/neoformat'

  -- Git, in vim!
  use 'tpope/vim-fugitive'
  use {
    'lewis6991/gitsigns.nvim',
  }
  -- Surround Things
  use 'tpope/vim-surround'

  -- Probably Going to Remove This
  use 'dstein64/vim-startuptime'
  use 'lewis6991/impatient.nvim'

  -- Highlight Hexcodes with their color
  use 'NvChad/nvim-colorizer.lua'

  -- Welcome Screen
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }
  }

  use({
    'noib3/nvim-cokeline',
    requires = 'kyazdani42/nvim-web-devicons',
  })


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
