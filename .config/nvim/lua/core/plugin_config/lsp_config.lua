require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "sumneko_lua" }
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, {})

  vim.keymap.set('n', '<leader>a', vim.diagnostic.goto_next, {})
  vim.keymap.set('n', '<leader>A', vim.diagnostic.goto_prev, {})
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

require("lspconfig").omnisharp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("lspconfig").tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("lspconfig").angularls.setup {
  on_attach = on_attach,
  root_dir = require('lspconfig').util.root_pattern("package.json", "tsconfig.base.json"),
  capabilities = capabilities,
}

require("lspconfig").eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}
