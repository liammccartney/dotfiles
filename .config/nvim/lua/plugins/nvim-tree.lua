return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local g = vim.g
    g.loaded_netrw = 1
    g.loaded_netrwPlugin = 1

    require("nvim-tree").setup()

    vim.keymap.set('n', '<leader>nn', ':NvimTreeFindFileToggle<CR>')
  end
}
