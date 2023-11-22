-- local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
  defaults = {
    mappings = {
      i = { ["<leader>tt"] = trouble.open_with_trouble },
      n = { ["<leader>tt"] = trouble.open_with_trouble },
    },
  },
}
