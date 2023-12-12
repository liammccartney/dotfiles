local neotest = require("neotest")

neotest.setup({
  adapters = {
    require("neotest-dotnet"),
    require("neotest-vim-test")({
      ignore_file_types = { "python", "vim", "lua" },
    }),
    require("neotest-jest")({
      jestCommad = "npx nx test -- "
    })
  },
})

vim.keymap.set('n', '<leader>t', neotest.run.run, {})
vim.keymap.set('n', '<leader>T', function () neotest.run.run(vim.fn.expand("%")) end , {})
