return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "jfpedroza/neotest-elixir",
    "nvim-neotest/neotest-jest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-elixir"),
        require('neotest-jest')({
          jestCommand = 'nx test',
        })
      },
    })
  end,
  keys = {
    {
      "<leader>t",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest Test",
    },
  },
}
