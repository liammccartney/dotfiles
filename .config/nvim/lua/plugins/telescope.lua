return {
  'nvim-telescope/telescope.nvim',
  version = false,
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-ui-select.nvim' }
    -- TODO: I don't know why I'd what telescope-fzf-native yet
    --{
    --  "nvim-telescope/telescope-fzf-native.nvim",
    --  build = "make",
    --  enabled = vm.fn.executable("make") == 1,
    --  config = function()
    --    Util.on_load("telescope.nvim", function()
    --      require("telescope").load_extension("fzf")
    --    end)
    --  end,
    --}
  },
  keys = {
    { '<c-f>', function() require('telescope.builtin').find_files() end, desc = "Find Files" },
    { '<c-b>', function() require('telescope.builtin').buffers() end, desc = 'Find Open Buffers' },
    desc = "Find Buffers",
    { '<leader>g',  function() require('telescope.builtin').live_grep() end,            desc = "Live Grep" },
    { '<leader>ss', function() require('telescope.builtin').lsp_document_symbols() end, desc = "Go to Symbol" },
  },
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<c-j>"] = {
              actions.move_selection_next,
              type = "action",
              opts = { nowait = true, silent = true }
            },
            ["<c-k>"] = {
              actions.move_selection_previous,
              type = "action",
              opts = { nowait = true, silent = true }
            },
            ["<ESC>"] = actions.close,
            ['<c-d>'] = actions.delete_buffer
          }
        }
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {}
        }
      }
    })

    require("telescope").load_extension("ui-select")
  end,
}
