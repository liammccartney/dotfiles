local function angular_root(fname)
  local lspconfig = require("lspconfig")
  return lspconfig.util.root_pattern("angular.json")(fname) or lspconfig.util.root_pattern("nx.json")(fname)
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          -- "omnisharp",
          "csharp_ls",
          "html",
          "jsonls",
          "angularls",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.base.json"),
        commands = {
          OrganizeImports = {
            organize_imports,
            description = "Organize Imports",
          },
        },
      })

      lspconfig.angularls.setup({
        capabilities = capabilities,
        root_dir = angular_root,
      })

      lspconfig.omnisharp.setup({
        cmd = { "dotnet", "/Users/liam/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern( "*.sln"),
      })

      lspconfig.html.setup({
        capabilities = capabilities,
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
      })

      lspconfig.elmls.setup({
        capabilities = capabilities,
      })

      lspconfig.eslint.setup({
        capabilities = capabilities,
      })

      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      lspconfig.somesass_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
      })

      lspconfig.graphql.setup({
        -- filetypes = { "graphql", "typescript", "typescriptreact", "javascriptreact" },
        capabilities = capabilities,
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
      })

      lspconfig.gdscript.setup({
        capabilities = capabilities,
      })

      lspconfig.pico8_ls.setup({
        cmd = { "pico8-ls", "--stdio" },
        capabilities = capabilities,
        filetypes = { "p8" },
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
      })

      -- TODO: Move to Lazy Keys Prop
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      -- TODO: Does Lazy Have a Autocmd Prop?
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }

          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)

          vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<F3>", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set({ "n", "v" }, "<F4>", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
  {
    "joeveiga/ng.nvim",
    config = function()
      local opts = { noremap = true, silent = true }
      local ng = require("ng")
      vim.keymap.set("n", "<leader>at", ng.goto_template_for_component, opts)
      vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file, opts)
      vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, opts)
    end,
  },
}
