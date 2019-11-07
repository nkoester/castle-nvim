"""""""""""""""""""""""""""""""""""""
" nkoester, 06062015 - intial vimrc
"""""""""""""""""""""""""""""""""""""

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings
" Must be first, because it changes other options as a side effect.
set nocompatible


"""""""""""""""""""""""""""""
" Miscellaneous settings ...
"""""""""""""""""""""""""""""
set number                     " Show line numbers <3
set number relativenumber      " relative and absolute line number mix
set hidden                     " Allow hidden buffers, don't limit to 1 file per window/split

set backspace=indent,eol,start " allow backspacing over everything in insert mode

if has("vms")
    set nobackup               " do not keep a backup file, use versions instead
else
    set backup                 " keep a backup file
endif

set history=300           " keep 50 lines of command line history
set ruler                 " show the cursor position all the time
set showcmd               " display incomplete commands
set showmode

set scrolloff=5           " distance to scrolling

set laststatus=2

highlight MatchParen cterm=bold ctermbg=none ctermfg=9  " bracket matching settings

if has('mouse')   " Enable mouse
  set mouse=a
endif

" tab completion mode with partial match and list
set wildmode=list:longest,full
set wildmenu

set wildchar=<Tab> wildmenu wildmode=full


""""""""""""""""""""
" Searching options
""""""""""""""""""""
set incsearch    " do incremental searching
set ignorecase   " Ignore case when searching
set smartcase    " ?

"""""""""""""""""""""""""""""
" Window width/wrapping
""""""""""""""""""""""""""""
set textwidth=79
set formatoptions-=t
set wrap
set linebreak
set nolist

"""""""""""""""""""""""""""""
" Tabbing, indentation etc.
"""""""""""""""""""""""""""""
set smarttab        " make 'tab' insert indents instead
                    " of tabs at the beginning of a line
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4
set softtabstop=4   " Sets the number of columns for a TAB
set expandtab       " Expand TABs to spaces


""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

""""""""""""""""""
" Key bindings
""""""""""""""""""

" Exit insert mode easily
"inoremap ii <Esc>l
inoremap jj <Esc>l

" Write file and return to what you were doing
inoremap <F2> <Esc>:w<CR>a
nnoremap <F2> :w<CR>
noremap W :update<CR>

" let mapleader="\<SPACE>"
map <space> <leader>
map <space><space> <leader><leader>


noremap <Leader>q :Sayonara<CR>
noremap <Leader>c :cclose<CR>
noremap <Leader>o :copen<CR>
noremap <Leader>e :e<CR>



" source the config file
inoremap <F5> <Esc>:source $MYVIMRC<CR>:echo "sourced $MYVIMRC"<CR>a
nnoremap <F5> :source $MYVIMRC<CR>:echo "sourced $MYVIMRC"<CR>

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" resize windows TODO: FIX
nnoremap <A-_> <C-W>+

nnoremap <A-=> <C-W>>
nnoremap <A--> <C-W><

" Control-Enter = append new line
nnoremap <C-J> A<CR><Esc>
" Map Ctrl-Space to insert a single space :)
nnoremap <NUL> i<Space><Esc>

" replace a word with currently yanked text
nnoremap S "_diwP

""""""""""""""""
" Auto completion
""""""""""""""""
" bind it to Ctrl-Space
inoremap <NUL> <C-n>

set completeopt=longest,menuone

"make enter work just as <C-Y> would when selction in popup
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"


""""""""""""""""
" Command def.
""""""""""""""""
" show changes: diff between the current buffer and loaded file
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
endif


""""""""""""""""
" Side explorer
""""""""""""""""
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
nnoremap <silent> <C-E> :call ToggleVExplorer()<CR>

" mode for wrapping text in the file
function! TextMode()
    :set formatoptions=tc
    :set fo+=a
    :set textwidth=80
endfunction

command! SetTextMode call TextMode()

" Hit enter in the file browser to open the selected file with :vsplit to the
" right of the browser.
let g:netrw_altv = 1
let g:netrw_winsize = -28              " absolute width of netrw window
"let g:netrw_banner = 0                " do not display info on the top of window
let g:netrw_liststyle = 3              " tree-view
let g:netrw_sort_sequence = '[\/]$,*'  " sort is affecting only: directories on the top, files below
let g:netrw_browse_split = 4           " use the previous window to open file
set autochdir                          " Change directory to the current buffer when opening files.

"""""""""""""""
" autocommands
"""""""""""""""
if has("autocmd")
      " say hello ^^
      autocmd VimEnter * echo "kitten <3 you     >^.^<  (meow)"

      " Enable file type detection.
      " load indent files to automatically do language-dependent indenting
      filetype plugin indent on

      " Put these in an autocmd group, so that we can delete them easily.
      augroup vimrcEx
          au!

          " For all text files set 'textwidth' to 78 characters.
          autocmd FileType text setlocal textwidth=78

          " When editing a file, always jump to the last known cursor position.
          autocmd BufReadPost
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

      augroup END

else

  set autoindent        " always set autoindenting on

endif


"""""""""""""""
" Spelling ...
"""""""""""""""
if has("spell")
    " set spell

    " toggle spelling with F4 key
    nnoremap <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
    inoremap <F4> <Esc>:set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>a

    nnoremap [s [sz=
    nnoremap ]s ]sz=

    set spell spelllang=en,de                          " spell checking
    "set spellfile=~/.vim/spell/techspeak.utf-8.add
    "highlight PmenuSel ctermfg=black ctermbg=lightgray " they were using white on white

    set sps=best,10       " limit it to just the top 10 items

    " allows spelling errors to be highlighted even if the line is selected
    "hi clear SpellBad
    "hi SpellBad cterm=bold ctermfg=red
    highlight clear SpellBad
    highlight SpellBad cterm=bold ctermbg=red
    highlight clear SpellCap
    highlight SpellCap cterm=bold ctermbg=166
    highlight clear SpellRare
    highlight SpellRare cterm=bold ctermbg=166
    highlight clear SpellLocal
    highlight SpellLocal cterm=bold ctermbg=166
endif

" remap stupid movement bindings
noremap ; l
noremap l k
noremap k j
noremap j h

" wraped line movement
noremap gl gk
noremap gk gj

" move blocks of lines with alt+jkl;
nnoremap <A-k> :m .+1<CR>==
nnoremap <A-l> :m .-2<CR>==
nnoremap <A-S-k> :m .+5<CR>==
nnoremap <A-S-l> :m .-7<CR>==

inoremap <A-k> <Esc>:m .+1<CR>==gi
inoremap <A-l> <Esc>:m .-2<CR>==gi
inoremap <A-S-k> <Esc>:m .+5<CR>==gi
inoremap <A-S-l> <Esc>:m .-7<CR>==gi

vnoremap <A-k> :m '>+1<CR>gv=gv
vnoremap <A-l> :m '<-2<CR>gv=gv
vnoremap <A-S-k> :m '>+5<CR>gv=gv
vnoremap <A-S-l> :m '<-7<CR>gv=gv


" split movement
nmap <c-Left> <c-w>h
nmap <c-Down> <c-w>j
nmap <c-Right> <c-w>l
nmap <c-Up> <c-w>k

" Use ctrl-[hjkl] to select the active split!
" note: it is imposible to map <c-;>
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


" buffer movement
map <a-Left> :bprevious<CR>
map <a-Right> :bnext<CR>


" pathogen setup
" execute pathogen#infect()
call plug#begin('~/.local/share/nvim/plugged')

" Plug 'https://github.com/elzr/vim-json.git', { 'for': ['json', 'distribution', 'project', 'template'] }
Plug 'https://github.com/elzr/vim-json.git' ", { 'for': ['json', 'distribution', 'project', 'template'] }

Plug 'https://github.com/dylon/vim-antlr.git', { 'for': ['g4'] }

"Plug 'https://github.com/altercation/vim-colors-solarized.git'
Plug 'https://github.com/flazz/vim-colorschemes.git'
Plug 'https://github.com/ervandew/supertab.git'
Plug 'https://github.com/vim-scripts/SearchComplete.git'
Plug 'https://github.com/easymotion/vim-easymotion.git'
Plug 'https://github.com/machakann/vim-sandwich'

" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'https://github.com/tpope/vim-unimpaired.git'

"Plug 'https://github.com/vim-syntastic/syntastic'
Plug 'https://github.com/w0rp/ale'
Plug 'https://github.com/rhysd/vim-grammarous'

Plug 'bkad/CamelCaseMotion'

Plug 'ntpeters/vim-better-whitespace'

Plug 'nathanaelkane/vim-indent-guides'

Plug 'tomtom/tcomment_vim'

"Plug 'itspriddle/ZoomWin'
Plug 'https://github.com/vim-scripts/zoomwintab.vim'

"Plug 'valloric/youcompleteme'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'

Plug 'davidhalter/jedi-vim'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'


Plug 'junegunn/goyo.vim'

" fold complete file for all not matching patterns
Plug 'embear/vim-foldsearch'

" latex stuff
Plug 'https://github.com/907th/vim-auto-save', { 'for': [ 'dem', 'md', 'txt' ] }
Plug 'lervag/vimtex'

" JS -,-
Plug 'https://github.com/jelera/vim-javascript-syntax', { 'for': [ 'js', 'html' ] }

" markdown magic
" all pretty much useless :/
" Plug 'https://github.com/vim-pandoc/vim-pandoc', { 'for': [ 'markdown', 'mrk', 'md', 'txt' ] }
" Plug 'https://github.com/vim-pandoc/vim-pandoc-syntax', { 'for': [ 'markdown', 'mrk', 'md', 'txt' ] }
" Plug 'gabrielelana/vim-markdown', { 'for': [ 'markdown', 'mrk', 'md', 'txt' ] }
" language collection
Plug 'sheerun/vim-polyglot'


"undo tree
Plug 'https://github.com/mbbill/undotree'

" table format
" Plug 'godlygeek/tabular', { 'for': [ 'markdown', 'mrk', 'md', 'txt' ] }
Plug 'https://github.com/dhruvasagar/vim-table-mode', { 'for': [ 'markdown', 'mrk', 'md', 'txt' ] }


Plug 'Raimondi/delimitMate'

" handle buffer closing in a smart-ish way
Plug 'mhinz/vim-sayonara'

" Autoformat files
Plug 'Chiel92/vim-autoformat'

" fuzzy file search
Plug 'cloudhead/neovim-fuzzy'

" treeee
Plug 'scrooloose/nerdtree'

" language server clien StringIOt
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug 'fatih/vim-go'
Plug 'OmniSharp/omnisharp-vim'


" grammar checking
" TODO: make this work with tex files, usless otherwise
"Plug 'https://github.com/rhysd/vim-grammarous'

" highlight current word in text
Plug 'dominikduda/vim_current_word'

" cypher syntax highlight
Plug 'neo4j-contrib/cypher-vim-syntax'

" make figlets :)
Plug 'fadein/vim-FIGlet'

" graphviz/dot
Plug 'https://github.com/wannesm/wmgraphviz.vim'

" highlights overused words // ToggleDitto
Plug 'https://github.com/dbmrq/vim-ditto'

" Thesaurus call
Plug 'ron89/thesaurus_query.vim'
call plug#end()

" ---------------------------
" Plugin Configurations
" ---------------------------


" ---------------------------
" langauge server stuff
" todo: diabled due to first entry fill bug?
let g:LanguageClient_autoStart = 1

let g:LanguageClient_serverCommands = {
    \'python' : ['/usr/bin/pyls',],
    \'go' : ['/usr/bin/gopls',],
    \'cs': ['/opt/omnisharp-roslyn/OmniSharp.exe',]
    \ }
" \'cs': ['omnisharp'],
" \ 'cs': ['mono', '/opt/omnisharp-roslyn/OmniSharp.exe', '--languageserver', '--verbose'],

nnoremap <C-l> :call LanguageClient_contextMenu()<CR>
let g:LanguageClient_useVirtualText = 1
" ---------------------------


" ---------------------------
" latex stuff
let g:vimtex_view_use_temp_files = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:tex_flavor = 'latex'
let g:polyglot_disabled = ['latex']
" does not work?
" let g:vimtex_index_split_width = 50
" ---------------------------


" ---------------------------
" Easy motion config
"map <S-Enter> <Plug>(easymotion-prefix)
" Move to word
map  <Leader><Leader>w <Plug>(easymotion-bd-w)
nmap <Leader><Leader>w <Plug>(easymotion-overwin-w)
"" Move to line
map <Leader><Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader><Leader>l <Plug>(easymotion-overwin-line)
" ---------------------------


" ---------------------------
" airline settings
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#whitespace#checks=['indent', 'mixed-indent-file']

"if !exists('g:airline_symbols')
"  let g:airline_symbols = {}
"endif
"let g:airline_symbols.space = "\ua0"

"the arrows are just stupid
let g:airline_left_sep='▙'
let g:airline_right_sep='▟'

" does not work?
"let g:airline#extensions#tabline#buffer_nr_show = 1
"let g:airline#extensions#tabline#buffer_nr_format = '%s: '

let g:airline_theme="badwolf"
" ---------------------------


" ---------------------------
" ale settings
let g:ale_echo_msg_format = '[%linter%] %s% (code)% [%severity%]'
" always check
let g:ale_lint_on_text_changed = 'never'
let g:ale_sign_error = '💣'
let g:ale_sign_warning = '🚩'
let g:ale_enabled = 0
" ---------------------------


" ---------------------------
" surround sandwich
let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
nmap s <Nop>
xmap s <Nop>
nmap <Leader>gl <Plug>(operator-sandwich-add)iwcgls<CR>
nmap <Leader>gp <Plug>(operator-sandwich-add)iwcglspl<CR>ex
nmap <Leader>tq <Plug>(operator-sandwich-add)iwctextquote<CR>
vmap <Leader>tq <Plug>(operator-sandwich-add)ctextquote<CR>
" ---------------------------


" ---------------------------
"CamelCaseMotion
call camelcasemotion#CreateMotionMappings('<leader>')
" ---------------------------


" ---------------------------
" current word highlight
let g:vim_current_word#enabled = 1
" Twins of word under cursor:
let g:vim_current_word#highlight_twins = 1
" The word under cursor:
let g:vim_current_word#highlight_current_word = 1

" highlight CurrentWord ctermbg=90
" highlight CurrentWordTwins ctermbg=54

let g:vim_current_word#twins_match_id = 502999
let g:vim_current_word#current_word_match_id = 502998

highlight CurrentWord ctermfg=15 ctermbg=15 cterm=bold
highlight CurrentWordTwins ctermfg=15 ctermbg=55 cterm=bold
" ---------------------------


" ---------------------------
" vim-better-whitespace
" trim on save
autocmd BufWritePre * StripWhitespace
" ---------------------------


" ---------------------------
" vim table mode
let g:table_mode_corner='|'
" autocmd BufNewFile,BufRead *.md execute !TableModeToggle
" ---------------------------


" ---------------------------
" Goyo config
let g:goyo_linenr=1
let g:goyo_height= '90%'
let g:goyo_width = 100
" ---------------------------


" ---------------------------
" vim-autosave
" enable if this is a file we define this for
let g:auto_save = 1
" ---------------------------


" ---------------------------
" autoformat file if possible
noremap <C-A-f> :Autoformat<CR>
" ---------------------------


" ---------------------------
"  fuzzy open
nnoremap <C-p> :FuzzyOpen<CR>
" ---------------------------


" ---------------------------
" undotree bindings
nnoremap <F6> :UndotreeToggle<cr>:UndotreeFocus<cr>
if has("persistent_undo")
    set undodir=~/.cache/nvim/undo/
    set undofile
endif
" ---------------------------


" ---------------------------
" nerdtree calling
nnoremap <F8> :NERDTreeToggle<cr>
" ---------------------------


" ---------------------------
" graphviz plugin settings
let g:WMGraphviz_viewer = "zathura"

" override the interactive mode to use xdot
fu! GraphvizInteractive()
    if !executable(g:WMGraphviz_dot)
        echoerr 'The "'.g:WMGraphviz_dot.'" executable was not found.'
    return
    endif

    silent exec '!xdot '.shellescape(expand('%:p')).' &'
endfu
" ---------------------------


" ---------------------------
" Use deoplete
let g:deoplete#enable_at_startup = 1

" deoplete completion for LaTeX
if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
endif
let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete

" deoplete setting or ultisnips
call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
" ---------------------------


" ---------------------------
" UltiSnips settings
" let g:UltiSnipsEditSplit = "context"
let g:UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
" let g:UltiSnipsSnippetDirectories = ["/home/nkoester/.local/share/nvim/plugged/vim-snippets/snippets/"]

"let g:UltiSnipsExpandTrigger="<tab>"
" termite already used default c-tab
let g:UltiSnipsListSnippets = "<A-tab>"
" use jkl; down/up motion
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-l>"
" ---------------------------


" ---------------------------
" supertab
" tab = go list down
"let g:SuperTabDefaultCompletionType = "<c-n>"
"or if your default completion type is currently context then you can use this instead:
" let g:SuperTabContextefaultCompletionType = "<c-n>"
" ---------------------------


" ---------------------------
" thesaurus config
nnoremap <Leader><Leader>t :ThesaurusQueryReplaceCurrentWord<CR>
let g:tq_enabled_backends=[ "openoffice_en",
            \"datamuse_com",
            \"openthesaurus_de",
            \"mthesaur_txt",]
let g:tq_language=['en', 'de']
" ---------------------------


" ---------------------------
" indent-guides
set ts=4 sw=4 et
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 4
let g:indent_guides_enable_on_vim_startup = 1
map <F3> <Esc>\ig:echo "Indent Guides toggle"<CR>
" ---------------------------




" ---------------------------
" ---------------------------
" non-plugin settings
" ---------------------------
" ---------------------------

" have multiple columns ofthe same document
noremap <silent> <Leader>mm :exe ColumnMode()<CR>
function! ColumnMode()
  exe "norm \<C-u>"
  let @z=&so
  set noscb so=0
  bo vs
  exe "norm \<PageDown>"
  setl scrollbind
  wincmd p
  setl scrollbind
  let &so=@z
endfunction


" avoid insert mode leave lag
set ttimeoutlen=10
" always show
set laststatus=2
" reduced from 4000
set updatetime=250
" allow project-specific settings
set exrc
set secure


" Auto lists: Automatically continue/end lists by adding markers if the
" previous line is a list item, or removing them when they are empty
function! s:auto_list()
  let l:preceding_line = getline(line(".") - 1)
  if l:preceding_line =~ '\v^\d+\.\s.'
    " The previous line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by one more character
    " i.e. it is an ordered list item

    " Continue the list
    let l:list_index = matchstr(l:preceding_line, '\v^\d*')
    call setline(".", l:list_index + 1. ". ")
  elseif l:preceding_line =~ '\v^\d+\.\s$'
    " The previous line matches any number of digits followed by a full-stop
    " followed by one character of whitespace followed by nothing
    " i.e. it is an empty ordered list item

    " End the list and clear the empty item
    call setline(line(".") - 1, "")
  elseif l:preceding_line[0] == "-" && l:preceding_line[1] == " "
    " The previous line is an unordered list item
    if strlen(l:preceding_line) == 2
      " ...which is empty: end the list and clear the empty item
      call setline(line(".") - 1, "")
    else
      " ...which is not empty: continue the list
      call setline(".", "- ")
    endif
  endif
endfunction
" N.B. Currently only enabled for return key in insert mode, not for normal
" mode 'o' or 'O'
if exists(':MarkdownEditBlock')
    inoremap <buffer> <CR> <CR><Esc>:call <SID>auto_list()<CR>A
endif


 " softwrap lines
set breakindent
let &showbreak = ' ↳ '
"showbreak="↳·"


" colors
set termguicolors
set background=dark
colorscheme jellybeans
highlight Normal ctermbg=none
highlight NonText ctermbg=none

"row
set cursorline
highlight CursorLine term=NONE cterm=NONE ctermbg=237
" makes it a bit faster to scroll ...
" set lazyredraw
" VS actually redraws when required (e.g. fullscreen)
"set nolazyredraw

"margin
set colorcolumn=80
highlight ColorColumn ctermbg=237

"visual
hi Visual term=reverse cterm=reverse guibg=Grey

"set the cursor shape depending on the mode
" NEOVIM new change
:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
"let &t_SI = "\<Esc>[6 q"
"let &t_SR = "\<Esc>[4 q"
"let &t_EI = "\<Esc>[2 q"

"reset cursor on exit
autocmd VimLeave * let &t_me="\<Esc>[6 q"


" well .. syntax
syntax enable

au BufNewFile,BufReadPost *.scxml set syntax=xml
" autocmd BufNewFile,BufReadPost *.scxml set filetype=xml
" markdown settings
"autocmd BufNewFile,BufReadPost *.md set filetype=markdown
"autocmd BufNewFile,BufReadPost *.markdown set filetype=markdown
"autocmd BufNewFile,BufReadPost *.mrk set filetype=markdown
"autocmd BufNewFile,BufReadPost *.txt set filetype=markdown

" better json
au BufRead,BufNewFile,BufReadPost *.json set syntax=json
au BufNewFile,BufRead,BufReadPost *.project set filetype=yaml
au BufNewFile,BufRead,BufReadPost *.distribution set filetype=yaml
au BufNewFile,BufRead,BufReadPost *.template set filetype=yaml
au BufNewFile,BufRead,BufReadPost *.project set filetype=yaml
au BufNewFile,BufRead,BufReadPost *.distribution set filetype=yaml
let g:vim_json_syntax_conceal = 0
au BufRead,BufNewFile,BufReadPost *.g4 set syntax=antlr
au BufRead,BufNewFile,BufReadPost *.md set syntax=markdown
au BufRead,BufNewFile,BufReadPost *.cypher set syntax=cypher
au BufRead,BufNewFile,BufReadPost *.cql set syntax=cypher

" special hidden chars
set listchars=tab:▸\ ,eol:¬
set list
" eol colour (232-255)
hi NonText ctermfg=65

" indent colors
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=234


" NEOVIM stuff
" copy paste to system clipboard
set mouse=c

set clipboard+=unnamedplus

" resize splits with + and -
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
endif

"" Copy to clipboard
"vnoremap  <leader>y  "+y
"nnoremap  <leader>Y  "+yg_
"nnoremap  <leader>y  "+y
"nnoremap  <leader>yy  "+yy
"
""" Paste from clipboard
"nnoremap <leader>p "+p
"nnoremap <leader>P "+P
"vnoremap <leader>p "+p
"vnoremap <leader>P "+P



" switch / move letters and words
nnoremap <silent> <A-C-j> Xph
nnoremap <silent> <A-C-;> xp

nnoremap <silent> scl Xph
nnoremap <silent> scr xp

nnoremap <silent> <A-j> "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
nnoremap <silent> <A-;> "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>

nnoremap <silent> swl "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o><c-l>:nohlsearch<CR>
nnoremap <silent> swr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>:nohlsearch<CR>

nnoremap <silent> <C-k> d$

set diffopt=internal,filler,iwhite

" use shift+0 to paste zero register (yank register)
nnoremap ) "0P


" quickfix window size
augroup quickfix_autocmds
  autocmd!
  autocmd BufReadPost quickfix call AdjustWindowHeight(2, 5)
augroup END

function! AdjustWindowHeight(minheight, maxheight)
  execute max([a:minheight, min([line('$') + 1, a:maxheight])])
        \ . 'wincmd _'
endfunction

