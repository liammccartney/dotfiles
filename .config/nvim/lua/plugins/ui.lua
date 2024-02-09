return {
    -- lazy.nvim
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            presets = {
                command_palette = true,
                lsp_doc_border = true,
            },
            lsp = {
                -- Got an error that the textDocument/hover handler was already set by another plugin
                -- must be lsp-zero
                -- Error message said to disable it
                hover = {
                    enabled = false,
                },
                -- Got an error that the textDocument/signatureHelp handler was already set by another plugin
                -- must be lsp-zero
                -- Error message said to disable it
                signature = {
                    enabled = false,
                },
            },
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify",
        },
    },
}
