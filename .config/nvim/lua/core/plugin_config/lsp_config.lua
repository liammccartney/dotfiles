require("mason").setup()
require("mason-lspconfig").setup()


local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
  vim.keymap.set('n', '<D-LeftMouse>', vim.lsp.buf.definition, {})
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})

  if client.name == 'html' or client.name == 'tsserver' or client.name == 'angularls' then
    vim.keymap.set('n', '<space>f', ':Neoformat prettier<cr>', {})
  else
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, {})
  end

  vim.keymap.set('n', '<leader>a', vim.diagnostic.goto_next, {})
  vim.keymap.set('n', '<leader>A', vim.diagnostic.goto_prev, {})

  if client.name == 'omnisharp' then
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      tokenModifiers[i] = v:gsub(' ', '_')
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      tokenTypes[i] = v:gsub(' ', '_')
    end
  end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("lspconfig").lua_ls.setup {
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

-- require("lspconfig").omnisharp.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

require("lspconfig").omnisharp.setup({
  -- cmd = { "C:/Users/bakkenl/scoop/shims/OmniSharp.exe", "--languageserver", "--hostPID", tostring(pid) },
  capabilities = capabilities,
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
  flags = {
    debounce_text_changes = 150,
  }
})

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

require("lspconfig").html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require("lspconfig").pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

require("lspconfig").elixirls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

require("lspconfig").cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

require("lspconfig").clojure_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- require('lspconfig').tailwindcss.setup({
--   on_attach = on_attach,
--   capabilities = capabilities
-- })

require('lspconfig').rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities
})

require('lspconfig').jsonls.setup({
  on_attach = on_attach,
  capabilities = capabilities
})
