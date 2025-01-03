return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
    config = function()
        local null_ls = require("null-ls")

        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.stylua,
                null_ls.builtins.formatting.prettier,
                -- require("none-ls.diagnostics.eslint"),
                null_ls.builtins.formatting.mix,
                null_ls.builtins.formatting.black,
                -- null_ls.builtins.formatting.csharpier,
                null_ls.builtins.formatting.mix,
            },
        })
    end,
}
