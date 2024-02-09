return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      -- TODO: Lazy Keys
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
      vim.keymap.set("n", "<F5>", dap.continue, {})
    end,
  },
}
