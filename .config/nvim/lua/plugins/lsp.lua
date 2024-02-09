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
                    "tsserver",
                    "omnisharp",
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

            lspconfig.tsserver.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.base.json"),
            })

            lspconfig.angularls.setup({
                capabilities = capabilities,
                root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.base.json"),
            })

            lspconfig.omnisharp.setup({
                capabilities = capabilities,
                -- TODO: Set root_dir to *.csproj or *.sln location instead?
                root_dir = lspconfig.util.find_git_ancestor,
            })

            lspconfig.html.setup({
                capabilities = capabilities,
            })

            lspconfig.jsonls.setup({
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
}
