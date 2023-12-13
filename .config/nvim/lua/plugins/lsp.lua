return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true
  },
  {
    'hrsh7th/cmp-nvim-lsp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'onsails/lspkind.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
          ['<cr>'] = cmp.mapping.confirm({ select = true }),
        }),
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = require('lspkind').cmp_format({
            mode = 'symbol',       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
          })
        }
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/nvim-cmp' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()
      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
      end)

      require('mason-lspconfig').setup({
        ensure_installed = {
          'tsserver',
          'eslint',
          'angularls',
          'html',
          'jsonls',
          'omnisharp',
          'elixirls'
        },
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
          angularls = function()
            local lspconfg = require('lspconfig')
            lspconfg.angularls.setup({
              root_dir = lspconfg.util.root_pattern("package.json", "tsconfig.base.json"),
            })
          end,
          omnisharp = function()
            local lspconfig = require('lspconfig')
            lspconfig.omnisharp.setup({
              root_dir = lspconfig.util.find_git_ancestor
            })
          end,
          tsserver = function()
            local lspconfg = require('lspconfig')

            lspconfg.tsserver.setup({
              root_dir = lspconfg.util.root_pattern("package.json", "tsconfig.base.json"),
            })
          end
        },
      })
    end
  },
}
