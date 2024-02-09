return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "c_sharp", "typescript", "gitcommit", "diff", "git_rebase", "git_config" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  }
}
