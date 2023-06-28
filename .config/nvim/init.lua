require("neodev").setup()
require("options")
require("keymaps")
require("plugins")

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
  { 'folke/tokyonight.nvim' },
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
  { "folke/neodev.nvim",              opts = {} },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  { 'nvim-telescope/telescope.nvim',  tag = '0.1.1', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
    end,
  }
})

vim.opt.termguicolors = true
vim.cmd.colorscheme('tokyonight')

local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'angularls',
  'html',
  'jsonls',
  'omnisharp'
})

local on_attach = function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })

  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = true })
end

lsp.on_attach(on_attach)

lsp.configure('angularls', {
  root_dir = require('lspconfig').util.root_pattern("package.json", "tsconfig.base.json"),
})

lsp.configure('omnisharp', {
  root_dir = require('lspconfig').util.find_git_ancestor,
  on_attach = function (client, bufnr)
    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      local tmp = string.gsub(v, ' ', '_')
      tokenModifiers[i] = string.gsub(tmp, '-_', '')
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      local tmp = string.gsub(v, ' ', '_')
      tokenTypes[i] = string.gsub(tmp, '-_', '')
    end
    on_attach(client, bufnr)
  end,
})

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
