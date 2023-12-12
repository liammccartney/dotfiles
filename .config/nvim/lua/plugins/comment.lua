-- TODO: Investigate
--  "JoosepAlviste/nvim-ts-context-commentstring",

return { 'echasnovski/mini.comment', 
version = false, 
config = function() 
  require('mini.comment').setup() 
end 
}
