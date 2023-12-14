-- Maybe Install?
--  "nvim-treesitter/nvim-treesitter-textobjects",

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  version = false,
  opts = {
    ensure_installed = { "lua", "vim", "c_sharp", "typescript" },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
    incremental_selection = { enable = true },
    indent = { enable = true }
  },
  config = function (_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end
}
