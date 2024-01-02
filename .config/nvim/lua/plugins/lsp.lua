return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      'hrsh7th/cmp-nvim-lsp'
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities
      })
    end,
    keys = {
      {'K', vim.lsp.buf.hover, desc = "Hover Docs"},
      {'gd', vim.lsp.buf.definition, desc = "Go To Definition"},
      {'gr', vim.lsp.buf.references, desc = "Find References" },
      {'<F4>', vim.lsp.buf.code_action, desc = 'Code Action'},
    }
  },
}
