return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'go', 'typescript', 'cs', 'htmlangular' },
      callback = function()
        vim.treesitter.start()
        -- indentation, provided by nvim-treesitter
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    })
  end
}
