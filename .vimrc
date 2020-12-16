" A lightly modified version of Gary Bernhardt's .vimrc file
" remove all existing autocmds
autocmd!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load ALL the Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
  Plug 'haishanh/night-owl.vim'
  Plug 'rakr/vim-one'
  Plug 'altercation/vim-colors-solarized'
  Plug 'itchyny/lightline.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'dense-analysis/ale'
  Plug 'tpope/vim-commentary'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tmhedberg/matchit'
  Plug 'majutsushi/tagbar'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'preservim/nerdtree'
  Plug 'mileszs/ack.vim'
  Plug 'elixir-editors/vim-elixir'
  Plug 'cespare/vim-toml'
  Plug 'ElmCast/elm-vim'
  Plug 'tpope/vim-abolish'
  Plug 'pangloss/vim-javascript'
  Plug 'jelera/vim-javascript-syntax'
  Plug 'leafgarland/typescript-vim'
  Plug 'Quramy/tsuquyomi'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'tweekmonster/django-plus.vim'
  Plug 'prettier/vim-prettier'
  Plug 'OmniSharp/omnisharp-vim'
  Plug 'nickspoons/vim-sharpenup'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'jlcrochet/vim-razor'
call plug#end()

"""""""""""""""""""""""""""""
" Basic Editing Configuration
"""""""""""""""""""""""""""""
set rtp+=/usr/local/opt/fzf
set nocompatible
" allow unsaved background buggers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
" No Tabs. Ever.
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
" Always display the status bar. We're not animals.
set laststatus=2
" On bracket insert briefly jump to the matching 
" bracket character if visible on screen.
set showmatch
" Incrementally show search results while typing search pattern
set incsearch
" Highlight all search matches
set hlsearch
" Make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" Limits number of screen lines used for the command line.
set cmdheight=1
" If a file is already open in a buffer, swtich to that buffer when
" opening it again, instead of creating a new buffer
set switchbuf=useopen
" Always show tab bar at the top
set showtabline=2
set winwidth=79
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" Keep more context when scrolling off the end of a buffer
set scrolloff=3
" No backups
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Display incomplete commands
set showcmd
" Enable syntax highlighting
syntax on
" Enable file type detection
" Load plugins, indentation files
filetype on
filetype plugin on
filetype indent on
" Completion mode defailts to longest match, lists all matches
set wildmode=longest,list
set wildmenu

set list
set listchars=tab:>-

" Show Line Numnbers
set number

set cc=79

let mapleader=","

" Fix slow 0 inserts
set timeout timeoutlen=1000 ttimeoutlen=100

" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1

" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3

" No Folding!
set foldmethod=manual
set nofoldenable

" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces

" If a file is changed outside of vim, automatically reload it without asking
set autoread

"""""""""""""""""""""""""""
" I have turnd this off, because I don't know if it's necessary anymore
" I suspect it might have been the culprit for my broken jsx & typescript
" syntax highlighting, but I have no proof as of March 30 2020
"""""""""""""""""""""""""""
" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
" set re=1

" Stop SQL language files from doing unholy things to the C-c key
let g:omni_sql_no_default_maps = 1

" Show side-by-side diffs, not above/below
set diffopt=vertical

" Write swap files to disk & trigger CursorHold event faster (default is
" after 4000 ms of inactivity)
set updatetime=200

" Completion options
"   menu: use a popup menu
"   preview: show more info in menu
set completeopt=menu,preview

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Autocmds
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") && match(expand("%"), '.git/COMMIT_MESSAGE/') == -1 |
        \   exe "normal g`\"" |
        \ endif
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


  " Python should have 4 spaces of indentation
  autocmd FileType python set sw=4 sts=4 et
  autocmd FileType php set sw=4 sts=4 et
  autocmd FileType html set sw=4 sts=4 et
  autocmd FileType javascript set sw=2 sts=2 et
  autocmd FileType typescript set sw=2 sts=2 et
  autocmd FileType typescript.tsx set sw=4 sts=4 et
  autocmd FileType typescriptreact set sw=4 sts=4 et
  autocmd FileType htmldjango set sw=4 sts=4 et
  autocmd FileType cs set sw=4 sts=4 et

  " autocmd BufReadPost public/modules/*/js/*.js :ALEDisable<cr>

  " Leave the reaturn key alone when in command line windows, since it's used
  " to run commands there
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

  " Compute syntax highlighting from beginning of file. (By default, vim only
  " looks 200 lines back, which can make it highlight code incorrectly in some
  " long files.)
  autocmd BufEnter * :syntax sync fromstart
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256 " 256 colors
set background=dark
colorscheme night-owl
let g:one_allow_italics=1

" Highlight current line.
set cursorline
hi clear CursorLine
hi CursorLine cterm=underline gui=underline

" True Colors for tmux
" https://github.com/tmux/tmux/issues/1246
if (has("termguicolors"))
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'nightowl',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ale Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
let g:ale_fix_on_save = 1

highlight ALEWarning cterm=underline,bold,italic ctermfg=Yellow
highlight ALEError cterm=underline,bold,italic ctermfg=Red

""""
" \ 'typescriptreact': ['eslint', 'tsserver'],
" \ 'typescript.tsx': ['eslint', 'tsserver'],
"""
let g:ale_linters = {
      \ 'cs': ['OmniSharp'],
      \ 'javascript': ['eslint'],
      \ 'typescript': ['eslint', 'tsserver'],
      \ 'php': ['php', 'phpcs'],
      \ 'python': ['pylint'],
      \ 'elixir': ['elixir-ls'],
      \}
" Disabled Fixers
"
"\'php': ['php_cs_fixer'],
"\'javascript': ['prettier'],
"\'cs': ['uncrustify'],
      " \'typescript': ['prettier'],
      " \'typescriptreact': ['prettier'],
let g:ale_fixers = {
      \'python': ['black'],
      \'elixir': ['mix_format'],
      \'json': ['prettier'],
      \}
let g:ale_php_phpcs_standard = "PSR12"
let g:ale_php_phpcs_options = "--exclude=Squiz.Functions.MultiLineFunctionDeclaration"
" let g:ale_php_phpcs_options = "--exclude=Generic.Commenting.Todo,Generic.Files.LineLength,PSR2.ControlStructures.ControlStructureSpacing,CakePHP.Strings.ConcatenationSpacing,PSR1.Files.SideEffects"

" let g:ale_python_black_options = "--skip-string-normalization"

let g:ale_elixir_elixir_ls_release = "/Users/liam/LanguageServers/elixir-ls/"
nnoremap <leader>a :ALENextWrap<cr>
nnoremap <leader>A :ALEPreviousWrap<cr>
nnoremap <leader>kA :ALEStopAllLSPs<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
nnoremap <leader><leader> <c-^>
" Align selected lines
vnoremap <leader>ib :!align<cr>
nnoremap <leader>w :w!<cr>
nnoremap <leader>W :wall!<cr>

nnoremap <leader>vs :vsplit<cr>
map <silent> <leader><cr> :noh<cr>
map <leader>q :e ~/buffer<cr> :set ft=markdown<cr>
map <leader>pp :setlocal paste!<cr>
map <leader>e :e! ~/.vimrc<cr>
map <leader>cc :cclose<cr> :pclose<cr>

map <Up> <C-o>
map <Down> <C-i>
noremap <Left> :bprev<cr>
noremap <Right> :bnext<cr>
nnoremap <leader>l :ls<cr>:b<space>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree Confg
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDTreeWinPos = "right"
nnoremap <leader>nn :NERDTreeToggle<cr>
nnoremap <leader>nm :NERDTreeFind<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
" inoremap <expr> <tab> InsertTabWrapper()
" inoremap <s-tab> <c-n>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
"
" Test running here is contextual in two different ways:
"
" 1. It will guess at how to run the tests. E.g., if there's a Gemfile
"    present, it will `bundle exec rspec` so the gems are respected.
"
" 2. It remembers which tests have been run. E.g., if I'm editing user_spec.rb
"    and hit enter, it will run rspec on user_spec.rb. If I then navigate to a
"    non-test file, like routes.rb, and hit return again, it will re-run
"    user_spec.rb. It will continue using user_spec.rb as my 'default' test
"    until I hit enter in some other test file, at which point that test file
"    is run immediately and becomes the default. This is complex to describe
"    fully, but simple to use in practice: always hit enter to run tests. It
"    will run either the test file you're in or the last test file you hit
"    enter in.
"
" 3. Sometimes you want to run just one test. For that, there's <leader>T,
"    which passes the current line number to the test runner. RSpec knows what
"    to do with this (it will run the first test it finds at or below the
"    given line number). It probably won't work with other test runners.
"    'Focusing' on a single test in this way will be remembered if you hit
"    enter from non-test files, as described above.
"
" 4. Sometimes you don't want contextual test running. In that case, there's
"    <leader>a, which runs everything.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MapCR()
  nnoremap <cr> :call RunTestFile()<cr>
endfunction
call MapCR()
nnoremap <leader>T :call RunNearestTest()<cr>

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Are we in a test file?
  let in_test_file = match(expand("%"),'\(_spec.rb\|_test.rb\|test.rkt\|_test.py\|Tests.cs\|_test.exs\?\)$') != -1

  " Run the tests for the previously-marked file (or the current file if
  " it's a test).
  if in_test_file
    call SetTestFile(command_suffix)
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile(command_suffix)
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  if expand("%") != ""
    :w
  end
  " The file is executable; assume we should run
  if executable(a:filename)
    exec ":!./" . a:filename
    " Project-specific test script
  elseif filereadable("bin/test")
    exec ":!bin/test " . a:filename
    " Rspec binstub
  elseif filereadable("bin/rspec")
    exec ":!bin/rspec " . a:filename
    " Fall back to the .test-commands pipe if available, assuming someone
    " is reading the other side and running the commands
  elseif filewritable(".test-commands")
    let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter --out tmp/quickfix'
    exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

    " Write an empty string to block until the command completes
    sleep 100m " milliseconds
    :!echo > .test-commands
    redraw!
    " Fall back to a blocking test run with Bundler
  elseif filereadable("bin/rspec")
    exec ":!bin/rspec --color " . a:filename
  elseif filereadable("Gemfile") && strlen(glob("spec/**/*.rb"))
    exec ":!bundle exec rspec --color " . a:filename
  elseif filereadable("Gemfile") && strlen(glob("test/**/*.rb"))
    exec ":!bin/rails test " . a:filename
    " If we see python-looking tests, assume they should be run with Nose
  elseif strlen(glob("*test.rb"))
    exec ":!ruby -r minitest/pride " . a:filename
  elseif strlen(glob("test/**/*.py"))
    exec "!nosetests " . a:filename
  elseif strlen(glob("*_test.py"))
    exec "!pytest " . a:filename
  elseif strlen(glob("tests/**/*.elm"))
    exec ":!elm-test " . a:filename
  elseif strlen(glob("*test.rkt"))
    exec ":racket " . a:filename
  elseif strlen(glob("test/**/*test.ex*"))
    exec ":!mix test " . a:filename
  elseif strlen(glob("*UnitTests/**/*Tests.cs"))
    exec ":!dotnet test --filter " . expand("%:t:r") 
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RemoveFancyCharacters COMMAND
" Remove smart quotes, etc.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CtrlP Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ctrlp_map = '<c-f>'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)|node_modules|vendor|elm-stuff|plugins|tmp|_build|deps|katielovell\/public|FulcrumProduct\/wwwroot\/codecoverage|netcoreapp3.1$',
      \ 'file': '\v\.(exe|so|dll|DS_Store|beam)$',
      \ 'link': '',
      \ }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CleanExtraSpaces
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! CleanExtraSpaces()
  let save_cursor = getpos(".")
  let old_query = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', save_cursor)
  call setreg('/', old_query)
endfun

autocmd BufWritePre *.php,*.phtml,*.ctp,*.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.rkt,*.ex,*.exs,*.rb,*.erl,*.md,*.leex,*.eex,*.razor,*.cs :call CleanExtraSpaces()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP CS Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:php_cs_fixer_config_file = '.php_cs'
" autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>t :TagbarToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gutentags Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable('.ctagsignore')
  let g:gutentags_ctags_exclude = ['@.ctagsignore']
endif

if filereadable('./FulcrumProduct.sln')
  let g:gutentags_enabled = 0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ack Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

"
" Sharpen Up
"
let g:sharpenup_map_prefix = '\'

"""""
" Deoplete
"""""
let g:deoplete#enable_at_startup = 1
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"""""
" OmniSharp
""""""
" let g:OmniSharp_selector_findusages = 'fzf'

let g:OmniSharp_popup_position = 'peek'
let g:OmniSharp_popup_options = {
\ 'highlight': 'Normal',
\ 'padding': [0, 1, 0, 1],
\ 'border': [1]
\}
let g:OmniSharp_popup_mappings = {
\ 'sigNext': '<C-n>',
\ 'sigPrev': '<C-p>',
\ 'pageDown': ['<C-f>', '<PageDown>'],
\ 'pageUp': ['<C-b>', '<PageUp>']
\}

let g:OmniSharp_highlight_groups = {
\ 'ExcludedCode': 'NonText'
\}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Tsuquyomi
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim-ale handles TypeScript quickfix, so tell Tsuquyomi not to do it.
let g:tsuquyomi_disable_quickfix = 1

