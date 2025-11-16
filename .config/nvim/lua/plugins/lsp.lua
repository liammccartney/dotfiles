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

    vim.lsp.config('lua_ls', { capabilities = capabilities })

    vim.lsp.config('tailwindcss', {})

    vim.lsp.config('csharp_ls', { capabilities = capabilities })

    local project_library_path = "ngserver"
    local cmd = { "ngserver", "--stdio", "--tsProbeLocations", project_library_path, "--ngProbeLocations",
      project_library_path }

    vim.lsp.config('ts_ls', ({
      capabilities = capabilities
    }))

    vim.lsp.config('angularls', {
      capabilities = capabilities,
      cmd = cmd,
      on_new_config = function(new_config, new_root_dir)
        new_config.cmd = cmd
      end,
    })

    vim.lsp.config('expert', {
      cmd = { 'expert' },
      root_markers = { 'mix.exs', '.git' },
      filetypes = { 'elixir', 'eelixir', 'heex' },
    })

    vim.lsp.config('jsonls', {
      capabilities = capabilities,
    })

    vim.lsp.config('elmls', {})

    vim.lsp.config('pyright', {})

    vim.lsp.enable({ 'lua_ls', 'angularls', 'csharp_ls', 'expert', 'ts_ls' })


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

    -- TODO: Does Lazy Have a Autocmd Prop?
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if not client then return end

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

        -- Angular-specific mapping for TypeScript files
        if vim.bo[ev.buf].filetype == "typescript" and client.name == "angularls" then
          vim.keymap.set("n", "gt", function()
            client:exec_cmd({
              title = "Go to template",
              command = "angular.goToTemplateForComponent",
              arguments = {
                vim.api.nvim_buf_get_name(0)
              }
            })
          end, opts)
        end
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
