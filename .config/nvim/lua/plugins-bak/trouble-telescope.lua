-- local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<leader>tr"] = trouble.open_with_trouble },
      n = { ["<leader>tr"] = trouble.open_with_trouble },
    },
  },
}
