local lsp = require('lsp-zero').preset({})

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'angularls',
  'html',
  'jsonls',
  'omnisharp',
  'elixirls'
})

local on_attach = function(_, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  local opts = { buffer = bufnr }

  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, { buffer = true })
  vim.keymap.set({ 'n', 'x' }, '<leader>f', function()
    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
  end, opts)
end


lsp.on_attach(on_attach)

lsp.configure('angularls', {
  root_dir = require('lspconfig').util.root_pattern("package.json", "tsconfig.base.json"),
})

lsp.configure('omnisharp', {
  root_dir = require('lspconfig').util.find_git_ancestor,
  on_attach = function(client, bufnr)
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

lsp.configure('graphql', {
  filetypes = { 'graphql', 'typescript' }
})

lsp.skip_server_setup({'tsserver', 'jsonls'})

lsp.setup()

require('typescript').setup({
  server = {
    on_attach = function (_, bufnr)
      vim.keymap.set('n', '<leader>ci', '<cmd>TypescriptAddMissingImports<cr>', {buffer = bufnr})
      vim.keymap.set('n', '<leader>or', '<cmd>TypescriptOrganizeImports<cr>', {buffer = bufnr})
      vim.keymap.set('n', '<leader>rr', '<cmd>TypescriptRemoveUnused<cr>', {buffer = bufnr})
    end
  }
})

-- How to do this in LSP Zero?
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require('lspconfig').jsonls.setup {
  capabilities = capabilities
}
