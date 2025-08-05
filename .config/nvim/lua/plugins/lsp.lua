return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {             -- make lua lsp vim aware
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require("lspconfig").lua_ls.setup { capabilities = capabilities }

    require 'lspconfig'.tailwindcss.setup {}

    require 'lspconfig'.csharp_ls.setup { capabilities = capabilities }

    require 'lspconfig'.clangd.setup {
      cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
    }

    require 'lspconfig'.rust_analyzer.setup {
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
          diagnostics = {
            enable = true,
          }
        }
      }
    }

    local project_library_path = "ngserver"
    local cmd = { "ngserver", "--stdio", "--tsProbeLocations", project_library_path, "--ngProbeLocations",
      project_library_path }

    require('lspconfig').ts_ls.setup({
      capabilities = capabilities
    })

    require 'lspconfig'.angularls.setup {
      capabilities = capabilities,
      cmd = cmd,
      on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
      end,
    }

    local path_to_elixir_ls = vim.fs.joinpath(vim.uv.os_homedir(), "Code/language-servers/elixir-ls/language_server.sh")
    require('lspconfig').elixirls.setup {
      cmd = { path_to_elixir_ls },
      capabilities = capabilities
    }

    require 'lspconfig'.jsonls.setup {
      capabilities = capabilities,
    }

    require 'lspconfig'.elmls.setup {}

    require 'lspconfig'.pyright.setup {}

    require 'lspconfig'.ruby_lsp.setup {}

    require 'lspconfig'.rubocop.setup {}

    require 'lspconfig'.fsautocomplete.setup {}

    require 'lspconfig'.sqls.setup {}

    require 'lspconfig'.gopls.setup { capabilities = capabilities }


    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then return end

        vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format() end)

        if client:supports_method('textDocument/formatting') and vim.bo.filetype == "lua" then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
            end
          })
        end
      end
    })

    -- TODO: Move to Lazy Keys Prop
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
    end)
    vim.keymap.set("n", "]d",
      function()
        vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
      end
    )
    vim.keymap.set("n", "[w", function()
      vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN })
    end)
    vim.keymap.set("n", "]w",
      function()
        vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.WARN })
      end
    )
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    vim.keymap.set("n", "<space>or",
      function()
        vim.lsp.buf.execute_command({
          command = "_typescript.organizeImports",
          arguments = {
            vim.api.nvim_buf_get_name(0)
          }
        })
      end)

    vim.keymap.set("n", "gt",
      function()
        vim.lsp.buf.execute_command({
          command = "_angular.goToTemplateFile",
          arguments = {
            vim.api.nvim_buf_get_name(0)
          }
        })
      end)

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

    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('EditAppSettings', {}),
      callback = function()
        vim.keymap.set('n', '<leader>ea', function()
          vim.cmd.edit('/Users/liam/Fulcrum/FulcrumProduct/FulcrumProduct/appsettings.json')
        end)
      end
    })
  end
}
