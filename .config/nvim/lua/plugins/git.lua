return {
  {
    'tpope/vim-fugitive'
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {},
    keys = {
      { '<leader>hp', ':Gitsigns preview_hunk<cr>',              silent = true, desc = "Preview Hunk" },
      -- I'd like to get this to be on by default
      { '<leader>ht', ':Gitsigns toggle_current_line_blame<cr>', silent = true, desc = "Preview Hunk" },
    },
  }
}
