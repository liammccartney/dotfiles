local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<c-j>"] = {
          actions.move_selection_next, type = "action",
          opts = { nowait = true, silent = true }
        },
        ["<c-k>"] = {
          actions.move_selection_previous, type = "action",
          opts = { nowait = true, silent = true }
        },
        ["<ESC>"] = actions.close,
        ['<c-d>'] = actions.delete_buffer
      }
    }
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}

vim.keymap.set('n', '<c-f>', builtin.find_files, {})
vim.keymap.set('n', '<c-b>', builtin.buffers, {})
vim.keymap.set('n', '<c-t>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>g', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, {})

-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")
