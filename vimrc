set nocompatible
filetype off

" -----------------------------------------------------------------------------
" Plugins
" -----------------------------------------------------------------------------

" Need for solarized plugin
execute pathogen#infect()

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Airline
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Languages
Plugin 'hdima/python-syntax'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'pangloss/vim-javascript'
Plugin 'adimit/prolog.vim'
Plugin 'mfukar/robotframework-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'alvan/vim-closetag'
Plugin 'fatih/vim-go'
Plugin 'psf/black'

" Tags
Plugin 'majutsushi/tagbar'
Plugin 'jstemmer/gotags'

" Visual stuff
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Lokaltog/powerline-fonts'

" Completion and Linting
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/ctrlp.vim'
Plugin 'w0rp/ale'
" Plugin 'ervandew/supertab' (Keeping this for when I can't use YCM)

" More Features
Plugin 'AndrewRadev/switch.vim'
Plugin 'dockyard/vim-easydir'
Plugin 'junegunn/vim-easy-align'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'paradigm/TextObjectify'
Plugin 'nathanaelkane/vim-indent-guides.git'
Plugin 'scrooloose/nerdtree'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'vim-scripts/tComment'
Plugin 'danro/rename.vim'

" -----------------------------------------------------------------------------
" General Options
" -----------------------------------------------------------------------------

filetype plugin indent on

set term=xterm-256color
set cursorline
set timeoutlen=1000 ttimeoutlen=0
set number
set backspace=indent,eol,start
syntax on

" Text line breaks
set formatoptions=l
set lbr
" set showbreak=↪

" Color Scheme
syntax enable
set background=light
colorscheme solarized

" Without this, some write events aren't processed by the OS
set backupcopy=yes

" GUI stuff
set guioptions-=m " Remove menu bar
set guioptions-=T " Remove toolbar
set guioptions-=r " Remove right-hand scroll bar

" Changes J behaviour
set formatoptions+=j

" Change TAB completion behavior
set wildmode=longest,list,full
set wildmenu

" Change how splits open
set splitright
set splitbelow

" Color of Tabs
:hi TabLineFill guifg=Black guibg=Black ctermfg=Black ctermbg=Black

" No double spaces after full stop
set nojoinspaces

" -----------------------------------------------------------------------------
" File Extensions
" -----------------------------------------------------------------------------

augroup FileExtentionsGroup
autocmd!

" Make .pl files load like Prolog and not like Perl
autocmd BufNewFile,BufRead *.pl :set ft=prolog

" Make .tex files load like tex files.
autocmd BufNewFile,BufRead *.tex :set ft=tex

" Make .md files load like Markdown files.
autocmd BufNewFile,BufRead *.md :set ft=markdown

" Make .rl file load as Go
autocmd BufNewFile,BufRead *.rl :set ft=go

" Make Emakefile files load like Erlang files.
autocmd BufNewFile,BufRead Emakefile :set ft=erlang

" Make ejs, and vue files load as HTML
autocmd BufNewFile,BufRead *.ejs :set ft=html
autocmd BufNewFile,BufRead *.vue :set ft=html

" Make .docker files load as Dockefile
autocmd BufNewFile,BufRead Dockerfile.* :set ft=dockerfile
autocmd BufNewFile,BufRead *.docker :set ft=dockerfile

augroup END

" -----------------------------------------------------------------------------
" Highlight Unwanted Spaces
" -----------------------------------------------------------------------------

" Defines the highlight of the extra white space, which will be red
highlight MyExtraWhitespace ctermbg=red guibg=red

fu! WhitespaceWinInit()
    if !exists("b:extra_whitespace")
        let b:extra_whitespace = 0
    endif

    if !exists("b:highlight_tabs")
        let b:highlight_tabs = 1
    endif

    if b:extra_whitespace == 0
        call WhitespaceApplyHighlight()
    else
        call WhitespaceRemoveHighlight()
    endif
endfu

fu! ToggleMyExtraWhitespace()
    if b:extra_whitespace == 0
        call WhitespaceRemoveHighlight()
        let b:extra_whitespace = 1
    else
        call WhitespaceApplyHighlight()
        let b:extra_whitespace = 0
    endif
endfu

fu! WhitespaceApplyHighlight()
    if b:highlight_tabs == 0
        match MyExtraWhitespace "\s\+$"
    else
        match MyExtraWhitespace "\s\+$\|\t\+"
    endif
endfu

fu! WhitespaceRemoveHighlight()
    call clearmatches()
endfu

fu! WhitespaceEnterInsert()
    if b:highlight_tabs == 0
        match MyExtraWhitespace "\s\+\%#\@<!$"
    else
        match MyExtraWhitespace "\s\+\%#\@<!$\|\t\+"
    endif
endfu

fu! WhitespaceLeaveInsert()
    if b:highlight_tabs == 0
        match MyExtraWhitespace "\s\+$"
    else
        match MyExtraWhitespace "\s\+$\|\t\+"
    endif
endfu

augroup ExtraWhitespaceGroup
    autocmd!
    autocmd WinEnter,BufWinEnter * :call WhitespaceWinInit()
    autocmd InsertEnter * :call WhitespaceEnterInsert()
    autocmd InsertLeave * :call WhitespaceLeaveInsert()
augroup END

" Toggle between extra whitespace highlight
nnoremap <silent> <leader>w :call ToggleMyExtraWhitespace()<CR>

" -----------------------------------------------------------------------------
" Indentation
" -----------------------------------------------------------------------------

fu! SetIndentTabs()
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set noexpandtab
endfu

fu! SetIndentWeb()
    set shiftwidth=2
    set softtabstop=2
    set tabstop=2
    set expandtab
endfu

fu! SetIndentDefault()
    set shiftwidth=4
    set softtabstop=4
    set tabstop=4
    set expandtab
endfu

" Set indent based on file type
fu! SetIndent()
    if &ft == "go" || &ft == "make"
        call SetIndentTabs()
        let b:highlight_tabs = 0
    elseif &ft == "html" || &ft == "javascript" || &ft == "typescript" || &ft == "css"
        call SetIndentWeb()
        let b:highlight_tabs = 1
    else
        call SetIndentDefault()
        let b:highlight_tabs = 1
    endif
endfu

augroup IndentGroup
autocmd!
autocmd BufWinEnter,FileType * :call SetIndent()
augroup END

" -----------------------------------------------------------------------------
" Folds
" -----------------------------------------------------------------------------

let c_no_comment_fold = 1

" Function to start using folds, but only when I want
fu! StartFolds()
    set foldnestmax=1     " Only fold one level
    set foldmethod=indent " Use syntax to determine where to fold
endfu

nnoremap <silent> <leader>z :call StartFolds()<CR>

" -----------------------------------------------------------------------------
" Language
" -----------------------------------------------------------------------------

fu! InitLanguage()
    let b:language = 0

    if &ft == "sql" ||
        \ &ft == "go" ||
        \ &ft == "typescript" ||
        \ &ft == "erl" ||
        \ &ft == "asm" ||
        \ &ft == "s"
        set nospell
    else
        set spell spelllang=en
    endif

endfu

fu! ToggleSpell()
    set spell!
endfu

" Function to toggle between the used languages
fu! ToggleLanguage()
    if &spell == 0
        return
    endif

    if b:language == 0
        set spelllang=pt
        let b:language = 1
    elseif b:language == 1
        set spelllang=de
        let b:language = 2
    else
        set spelllang=en
        let b:language = 0
    endif
endfu

" Initialize language variables for every new buffer
augroup Language
autocmd!
autocmd BufWinEnter,FileType * :call InitLanguage()
augroup END

" Toggle between the languages, or just toggle the spell functionality
nnoremap <silent> <leader>a :call ToggleLanguage()<CR>
nnoremap <silent> <leader>s :call ToggleSpell()<CR>

" Underline spelling mistakes
hi clear SpellBad
hi SpellBad cterm=underline

" -----------------------------------------------------------------------------
" Key Binds
" -----------------------------------------------------------------------------

" Stop using the arrows
map <left> <nop>
map <down> <nop>
map <up> <nop>
map <right> <nop>

" Use Ctrl-{hjkl} to move between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Handle Tabs
nnoremap <silent> <C-o> :tabprevious<CR>
nnoremap <silent> <C-p> :tabnext<CR>
nnoremap <silent> <C-t> :tabnew<CR>
nnoremap <leader>q :tabclose<CR>

" End with the W and Q not defined annoyance
com W w
com Q q

" Write 79 = or -
map <F2> 79I=<ESC>
map <leader><F2> 79I-<ESC>

" Put a (DONE) word at beginning of line
nnoremap <F3> I(DONE) <ESC>

" Press f4 to go to a line and paste something
map <F4> ggp
map <leader><F4> ggP

" Press f5 to make a text "something. Else", into "something, else".
" <leader>f5 for the opposite
map <F5> gulhhx
map <leader><F5> gUlhhr.

" Put a python print statement around the current line, or remove it. This
" could be vastly improved.
map <F6> Iprint(<ESC>A)<ESC>
map <leader><F6> 0wdwx$x

" Make it easy to use EasyAlign
vnoremap <silent> <leader><Enter> :EasyAlign<Enter>

" Use ç to work with registers
noremap ç "

" Stay selected while indenting
vnoremap < <gv
vnoremap > >gv

" Disables the ex mode
nnoremap Q <nop>

" Splits
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>b :split<CR>

" -----------------------------------------------------------------------------
" Status Line, Airline Settings
" -----------------------------------------------------------------------------

set laststatus=2

let g:airline_powerline_fonts=1
let g:airline_section_z = airline#section#create(['%L L', ' ', '%l,%v'])
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy
let g:airline#extensions#ale#enabled = 1

" -----------------------------------------------------------------------------
" Python
" -----------------------------------------------------------------------------

autocmd BufWritePre *.py execute ':Black'

" -----------------------------------------------------------------------------
" Go
" -----------------------------------------------------------------------------

let g:go_def_mapping_enabled = 0
let g:go_fmt_command = "goimports"

" -----------------------------------------------------------------------------
" Rainbow Parentheses Stuff
" -----------------------------------------------------------------------------

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" -----------------------------------------------------------------------------
" YouCompleteMe Stuff
" -----------------------------------------------------------------------------

nnoremap <silent> yt <C-o>
nnoremap <silent> yg :YcmCompleter GoToDeclaration<CR>
nnoremap <silent> yh :YcmCompleter GoToDefinition<CR>
nnoremap <silent> yj :YcmCompleter GetDoc<CR>
nnoremap <silent> yu :YcmCompleter GoToReferences<CR>

let g:ycm_python_binary_path = 'python3'
let b:ycm_hover = ''
let g:ycm_auto_trigger = 1
let g:ycm_autoclose_preview_window_after_completion = 1

" Toggle ycm auto trigger (Is there a more compact way to do this?)
fu! ToggleYCM()
    if g:ycm_auto_trigger == 1
        let g:ycm_auto_trigger = 0
    else
        let g:ycm_auto_trigger = 1
    endif
endfu

map <leader>y :call ToggleYCM()<CR>

" -----------------------------------------------------------------------------
" ALE
" -----------------------------------------------------------------------------

let g:ale_sign_column_always = 1

let g:ale_linters = {
\   'python': ['flake8'],
\   'javascript': ['eslint'],
\}

" let g:ale_python_flake8_executable = 'python3'
let g:ale_python_flake8_use_global = 1
let g:ale_python_flake8_options = '--ignore E501,W503,W605,D'

map <leader>l :ALEToggle<CR>

" -----------------------------------------------------------------------------
" Ctrl+P
" -----------------------------------------------------------------------------

let g:ctrlp_map = '<c-i>'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|\.git\|venv\|__pycache__'

" -----------------------------------------------------------------------------
" NERDTree
" -----------------------------------------------------------------------------

" Clode vim if NERDTree is the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Symbols
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

nnoremap <silent> <leader>n :NERDTreeToggle<CR>

" -----------------------------------------------------------------------------
" Tags Stuff
" -----------------------------------------------------------------------------

nnoremap <silent> <leader>t :TagbarToggle<CR>
nnoremap <silent> yt <C-o>
nnoremap <silent> yg <C-]>

let g:tagbar_sort = 0
let g:easytags_async = 1

" For golang
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" -----------------------------------------------------------------------------
" Switch stuff
" -----------------------------------------------------------------------------

let g:switch_custom_definitions = [['and', 'or']]

" -----------------------------------------------------------------------------
" Indent Json
" -----------------------------------------------------------------------------

fu! Json()
    :%!python -m json.tool
endfu

com Json call Json()

" -----------------------------------------------------------------------------
" Get offset in bytes of current cursor position in file
" -----------------------------------------------------------------------------

fu! Offset()
    let l:offset = eval(line2byte(line("."))+col("."))
    if l:offset >= 2
        let l:offset = l:offset-2
    endif
    echo l:offset
endfu

com Offset call Offset()

" -----------------------------------------------------------------------------
" Indent Python in the Google way.
"
" https://google.github.io/styleguide/pyguide.html
" -----------------------------------------------------------------------------

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"
