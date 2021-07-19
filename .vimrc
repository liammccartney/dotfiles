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
  " Theme
  Plug 'arcticicestudio/nord-vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'ryanoasis/vim-devicons'

  " Status Bar
  Plug 'itchyny/lightline.vim'

  " tpope, lord of vim plugins
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-surround'

  " Git Helpers
  Plug 'airblade/vim-gitgutter'

  " ALE, for Linting
  Plug 'dense-analysis/ale'

  " file finder, buffer manager
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'yegappan/mru'
  Plug 'pbogut/fzf-mru.vim'

  " Extends % to match many more kinds of surrounding symbols
  Plug 'tmhedberg/matchit'

  " ctags explorer for current file
  Plug 'majutsushi/tagbar'

  " Generate ctags in background
  Plug 'ludovicchabant/vim-gutentags'

  " File tree
  Plug 'preservim/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " For when tags fail, there's always Ack
  " Configure this to use `ag`
  Plug 'mileszs/ack.vim'
  
  " Syntax
  " Plug 'elixir-editors/vim-elixir'
  " Plug 'cespare/vim-toml'
  " Plug 'ElmCast/elm-vim'
  " Plug 'leafgarland/typescript-vim'
  " Plug 'jlcrochet/vim-razor'

  " Language specifc semantics
  " Plug 'Quramy/tsuquyomi'
  Plug 'OmniSharp/omnisharp-vim'
  Plug 'nickspoons/vim-sharpenup'
  " Plug 'dart-lang/dart-vim-plugin'

  Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }

  " Autocomplete
  Plug 'neoclide/coc.nvim', {'branch': 'release'}


  Plug 'vimwiki/vimwiki'
call plug#end()

"""""""""""""""""""""""""""""
" Basic Editing Configuration
"""""""""""""""""""""""""""""
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
  autocmd FileType html set sw=2 sts=2 et
  autocmd FileType hbs set sw=2 sts=2 et
  autocmd FileType javascript set sw=2 sts=2 et
  autocmd FileType typescript set sw=2 sts=2 et
  autocmd FileType typescript.tsx set sw=4 sts=4 et
  autocmd FileType typescriptreact set sw=4 sts=4 et
  autocmd FileType htmldjango set sw=4 sts=4 et
  autocmd FileType cs set sw=4 sts=4 et
  autocmd FileType scss set sw=2 sts=2 et

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
set termguicolors
colorscheme nord

" Highlight current line.
set cursorline
hi clear CursorLine
hi CursorLine cterm=underline gui=underline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'right': [
      \     ['lineinfo'], ['percent'],
      \     ['fileformat', 'fileencoding', 'filetype', 'sharpenup']
      \   ]
      \ },
      \ 'inactive': {
      \   'right': [['lineinfo'], ['percent'], ['sharpenup']]
      \ },
      \ 'component': {
      \   'sharpenup': sharpenup#statusline#Build()
      \ },
      \}

let g:sharpenup_statusline_opts = { 'Text': '%s (%p/%P)' }
let g:sharpenup_statusline_opts.Highlight = 0

augroup OmniSharpIntegrations
    autocmd!
    autocmd User OmniSharpProjectUpdated,OmniSharpReady call lightline#update()
augroup END

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 0

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
map <leader>cc :cclose<cr> :pclose<cr> :lclose<cr>

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
  elseif filereadable("mix.exs")
    exec ":!mix test " . a:filename
  elseif strlen(glob("*UnitTests/**/*Tests.cs"))
    exec ":OmniSharpRunTestsInFile"
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
" FZF Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <c-f> :FZF<CR>
nmap <c-b> :Buffers<CR>
nnoremap  <silent> <leader>g :FZFMru<CR>
nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>

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

autocmd BufWritePre *.php,*.phtml,*.ctp,*.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.rkt,*.ex,*.exs,*.rb,*.erl,*.md,*.leex,*.eex,*.razor,*.cs,*.ts,*.html,*.elm :call CleanExtraSpaces()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PHP CS Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:php_cs_fixer_config_file = '.php_cs'
" autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Gutentags Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun FindCtagsIgnore()
  if filereadable(findfile(".ctagsignore", ".;"))
    let g:gutentags_ctags_exclude = ["@" . findfile(".ctagsignore", ".;")]
  endif
endfun
call FindCtagsIgnore()

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
let g:OmniSharp_selector_ui = 'fzf'

" Popup configuration
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

"""""""
"" ALE
"" Currently only used for C# files, CoC handles everything else
"""""""
let g:ale_linters = {
      \ 'cs': ['OmniSharp'],
      \ 'typescript': [],
      \ 'python': [],
      \ 'terraform': [],
      \ 'go': [],
      \ 'elm': ['make'],
      \ 'elixir': [],
      \}

let g:ale_fixers = {
      \ 'elm': ['elm-format'],
      \ 'elixir': [],
      \}

let g:ale_fix_on_save = 1


autocmd FileType cs nmap <silent> <leader>a  <Plug>(ale_next_wrap_error)
autocmd FileType cs nmap <silent> <leader>A  <Plug>(ale_previous_wrap_error)

highlight ALEWarning cterm=underline,bold,italic ctermfg=Yellow
highlight ALEError cterm=underline,bold,italic ctermfg=Red
highlight ALEInfo cterm=underline,bold,italic ctermfg=130

highlight clear ALEErrorSign
highlight clear ALEWarningSign
highlight clear ALEInfoSign

let g:ale_sign_error = '💥'
let g:ale_sign_warning = '😬'
let g:ale_sign_info = '❗️'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Coc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=UTF-8
set updatetime=300
set cmdheight=2
set shortmess+=c
set signcolumn=yes

augroup coc
  autocmd FileType typescript call ConfigureCoc()
  autocmd FileType javascript call ConfigureCoc()
  autocmd FileType json call ConfigureCoc()
  autocmd FileType html call ConfigureCoc()
  autocmd FileType python call ConfigureCoc()
  autocmd FileType terraform call ConfigureCoc()
  autocmd FileType go call ConfigureCoc()
  autocmd FileType vim call ConfigureCoc()
  autocmd FileType css call ConfigureCoc()
  autocmd FileType scss call ConfigureCoc()
  autocmd FileType elixir call ConfigureCoc()
  autocmd FileType sql call ConfigureCoc()
augroup END

autocmd FileType scss setl iskeyword+=@-@

fun! ConfigureCoc()
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  inoremap <silent><expr> <c-@> coc#refresh()

  inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  nmap <leader>ca  <Plug>(coc-codeaction)
  nmap <leader>qf  <Plug>(coc-fix-current)

  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)

  nmap <leader>rn <Plug>(coc-rename)

  nnoremap <silent> K :call <SID>show_documentation()<CR>
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  nmap <silent> <leader>A <Plug>(coc-diagnostic-prev)
  nmap <silent> <leader>a <Plug>(coc-diagnostic-next)

  highlight CocWarningHighlight cterm=underline,bold,italic ctermfg=Yellow
  highlight CocErrorHighlight cterm=underline,bold,italic ctermfg=Red
  highlight CocInfoHighlight cterm=underline,bold,italic ctermfg=130

  command! -nargs=0 Prettier :CocCommand prettier.formatFile

  autocmd CursorHold * silent call CocActionAsync('highlight')
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  let $NVIM_TUI_ENABLE_TRUE_COLOR=1


  autocmd BufNewFile,BufRead *.razor call TextEnableCodeSnip('cs', '@code {', '\n}', 'SpecialComment')
endfun

" Enables vaguely correct syntax highlighting for razor files
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
        \ matchgroup='.a:textSnipHl.'
        \ keepend
        \ start="'.a:start.'" end="'.a:end.'"
        \ contains=@'.group
endfunction


""""""""""""
" hexokinase
""""""""""""
let g:Hexokinase_highlighters = ['sign_column']
