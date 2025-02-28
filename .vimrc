if &compatible
  set nocompatible
endif

filetype off

"
" PLUGINS
"

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-rails'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'jremmen/vim-ripgrep'
Plug 'gennaro-tedesco/nvim-peekup'
Plug 'dense-analysis/ale'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rking/ag.vim'
Plug 'mtth/scratch.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
" Syntax
Plug 'ekalinin/Dockerfile.vim'
Plug 'mxw/vim-jsx'
Plug 'othree/yajs.vim'
Plug 'chrisbra/csv.vim'
Plug 'othree/html5.vim'
Plug 'racer-rust/vim-racer'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'stephpy/vim-yaml'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Telescope setup
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'kkharji/sqlite.lua'
Plug 'danielfalk/smart-open.nvim'
" Colorschemes
Plug 'tomasiser/vim-code-dark'

call plug#end()

filetype plugin indent on
set encoding=utf-8

"
" DISPLAY
"

set scrolloff=2
set nocp
set et
set nobackup
set wrap linebreak nolist
set autoindent
set smartindent
set ai
set ruler
set relativenumber
set cursorline
set undofile
set undodir=~/.vim-tmp
set backspace=indent,eol,start
set laststatus=2
set showcmd
set showmode
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set shell=/bin/bash
set title
set formatprg=par
set spelllang=en_us
set autoread
set lazyredraw
syntax enable
colorscheme codedark
set background=dark
hi Normal ctermbg=none

"
" MODELINE
"

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

"
" CURSOR
"

let &t_SI = "\e[4 q"
let &t_EI = "\e[2 q"

augroup myCmds
  au!
  autocmd VimEnter * silent !echo -ne "\e[2 q"
  autocmd VimLeave * silent !echo -ne "\e[1 q"
augroup END

"
" WINDOW/PANES
"

set scrolljump=4
set winminwidth=2
set winwidth=80
set winheight=7
set winminheight=7
set winheight=999

if exists('+relativenumber')
  autocmd WinLeave *
    \ if &rnu==1 |
    \ exe "setl norelativenumber" |
    \ exe "setl nu" |
    \ endif
  autocmd BufRead,BufNewFile,BufEnter,WinEnter *
    \ if &rnu==0 |
    \ exe "setl rnu" |
    \ endif
endif

autocmd BufNewFile,BufRead *.es6 set filetype=javascript
autocmd BufNewFile,BufRead *.jsx set filetype=javascript
autocmd BufNewFile,BufRead *.json set filetype=json
let g:jsx_ext_required = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_python_checkers=['flake8']
let g:syntastic_ruby_checkers = ['mri']
let g:syntastic_aggregate_errors = 1

let g:rustfmt_autosave = 1
let g:rust_clip_command = 'pbcopy'

"
" SEARCH
"

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set matchpairs+=<:>

"
" TABS/WRAPPING
"

set softtabstop=2
set tabstop=2
set shiftwidth=2
set expandtab
set wrap
set textwidth=80
set formatoptions=qrn1
set listchars=tab:▸\ ,eol:¬

"
" KEYBOARD
"

if !has('nvim')
  set noesckeys
endif

let mapleader = ","
nnoremap <leader><leader> <c-^>
nnoremap <leader>v `[v`]
nnoremap ; :
nmap <silent> <leader>s :set spell!<CR>
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
nnoremap <leader>rg :Rg 
nnoremap <leader>rl :source $MYVIMRC<cr>
nnoremap <leader>rv <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>w <C-w>v
nnoremap <leader>W <C-w>s
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nmap <leader><tab> :Scratch<cr>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>c :!jbuilder runtest %%<cr>
nnoremap <leader>rm :call delete(expand('%')) \| bdelete!<cr>

command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>
command! -bang Q quit<bang>

"
" FILETYPES
"

autocmd FileType make setlocal noexpandtab
augroup vimrcEx
  autocmd!
  autocmd FileType text setlocal textwidth=78
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python,Dockerfile set ts=4 sw=4 sts=4 et
  autocmd! BufRead,BufNewFile .babelrc setfiletype json
  autocmd! BufRead,BufNewFile .eslintrc setfiletype json
  autocmd! BufRead,BufNewFile *.sass setfiletype sass 
  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:>
  autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescriptreact
  autocmd! FileType mkd setlocal syn=off
augroup END

autocmd FileType fish compiler fish

"
" VIM SPLITJOIN
"

nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

"
" HTML
"

let html_no_rendering=1
if filereadable(expand("~/.vim/bundle/html5.vim/autoload/htmlcomplete.vim"))
  so ~/.vim/bundle/html5.vim/autoload/htmlcomplete.vim
endif

"
" TELESCOPE CONFIGURATION
"
nnoremap <C-p> :Telescope smart_open cwd_only=true<CR>
nnoremap <leader>f :Telescope smart_open<CR>
nnoremap <leader>t :Telescope tags<CR>
nnoremap <leader>. :Telescope oldfiles<CR>
nnoremap <leader>gb :Telescope buffers<CR>
nnoremap <leader>gf :Telescope smart_open cwd=%:p:h cwd_only=true<CR>
nnoremap <leader>gh :OpenGithubFile<CR>
nnoremap <leader>gv :Telescope smart_open cwd=app/views<CR>

"
" RAILS
"

map <leader>gr :topleft :split config/routes.rb<CR>
map <leader>gg :topleft 100 :split Gemfile<CR>

"
" OMNICOMPLETE
"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction
au VimEnter * inoremap <tab> <c-r>=InsertTabWrapper()<CR>

"
" COPY/PASTE
"

function PBCopy() range
  echo system('echo '.shellescape(join(getline(a:firstline, a:lastline), "\n")).'| clip.exe')
endfunction

map <leader>p :read !powershell.exe Get-Clipboard<CR>
map <leader>y :'<,'>call PBCopy()<CR>

"
" AG: THE SILVER SEARCHER
"

let g:ag_lhandler="copen 20"
let g:ag_qhandler="copen 20"
nnoremap <leader>A :Ag!<space>

" OPAM CONFIG (unchanged)
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')
let s:opam_configuration = {}
function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')
function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')
function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')
let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor

" Autoreload files
if !exists("g:CheckUpdateStarted")
    let g:CheckUpdateStarted=1
    call timer_start(1,'CheckUpdate')
endif
function! CheckUpdate(timer)
    silent! checktime
    call timer_start(1000,'CheckUpdate')
endfunction
