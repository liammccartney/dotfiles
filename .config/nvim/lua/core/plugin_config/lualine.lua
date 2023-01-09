local navic = require('nvim-navic')
require('lualine').setup {
  options = {
    icons_enabled = true,
  },
  sections = {
    lualine_a = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_c = {
      {
        'lsp_progress', { navic.get_location, cond = navic.is_available }
      }
    }
  }
}
