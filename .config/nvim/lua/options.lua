local o = vim.o

-- Include a lot of past commands so seaching them
-- is useful
o.history = 10000

-- Show Line Numbers
o.number = true
o.relativenumber = true
-- Show Signs in the same column as the Numbers
-- Prevents horizontal janky jumps
-- o.signcolumn = "number"
--
-- Use Spaces, which I understand is less
-- accessible but I'm not used to tabs yet
o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.autoindent = true

-- Make searches case-sensitive only if they contain upper-case character
o.ignorecase = true
o.smartcase = true

-- Incremental Seach
o.incsearch = true

-- Highlight search results
o.hlsearch = true

-- Briefly jump to matching brace or keyword
-- on insert
o.showmatch = true
o.matchtime = 3

-- Prevent neovim from yelling that I'm opening a new buffer
-- without saving the current one
o.hidden = true

-- If file already open in a buffer, go there
o.switchbuf = "useopen"

-- Highlight Current Line
o.cursorline = true

o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true

o.termguicolors = true

o.backupcopy = "yes"
