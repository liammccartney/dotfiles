return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  opts = {
    keywords = {
      V3SHIPPING = { icon = "🚚", color = "warning" },
    },
    merge_keywords = true
  },
  keys = {
    { "<leader>td", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  },
}
