local o = vim.o

o.number = true
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.autoindent = true
o.signcolumn = 'number'

-- Make searches case-sensitive only if they contain upper-case character
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true
o.showmatch = true
