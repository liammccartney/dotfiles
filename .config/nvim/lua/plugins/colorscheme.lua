return {
  "catppuccin/nvim",
  lazy = true,
  name = "catpuccin",
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("catppuccin")
  end
}
