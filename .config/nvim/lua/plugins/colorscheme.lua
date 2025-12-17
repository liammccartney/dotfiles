-- return {
--   "rebelot/kanagawa.nvim",
--   name = "kanagawa",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("kanagawa").setup({
--       compile = false,
--       undercurl = true,
--       commentStyle = { italic = true },
--       keywordStyle = { italic = false },
--       statementStyle = { bold = true },
--       transparent = false,
--       dimInactive = false,
--       terminalColors = true,
--
--       colors = {
--         theme = {
--           all = {
--             ui = {
--               bg_gutter = "none",
--             },
--           },
--         },
--       },
--     })
--
--     -- pick one:
--     vim.cmd("colorscheme kanagawa-wave") -- default
--   end,
-- }

-- lua/plugins/rose-pine.lua
return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    vim.cmd("colorscheme rose-pine-moon")
  end
}
