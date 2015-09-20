set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'

"" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'

"" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'

"" The sparkup vim script is in a subdirectory of this repo called vim.
"" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

"" Avoid a name conflict with L9
"Plugin 'user/L9', {'name': 'newL9'}
"

" True Sublime Text style multiple selections for Vim 
Plugin 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
" Default mapping
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" use cs"' to replace surroundings (" -> ')
" use cst' to replace complex surroundings (<href> -> ')
" use dst" to remove surroundings
" use ysiw" to surround a single word (hello -> "hello")
" use yss" to surround the whole line
Plugin 'tpope/vim-surround'

" repeat plugin-commands by using . (not just native commands)
Plugin 'tpope/vim-repeat'

" renaming of variables using cAsE correctly:
" :%Subvert/facilit{y,ies}/building{,s}/g
"  crs -> snake_case
"  crm -> MixedCase
"  crc -> camelCase
"  cru -> UPPER_CASE
"  Also does abolishments (auto-replacing of miss-typed words)
"  see ~/.vim/after/plugin/abolish.vim
Plugin 'tpope/vim-abolish'

" comment with gc or gcc
Plugin 'tpope/vim-commentary'

" clipboard (i.e. over multiple instances of vim)
" Plugin 'svermeulen/vim-easyclip'

" Syntax highlighting for systemd service files in Vim.
Plugin 'Matt-Deacalion/vim-systemd-syntax'

" additional vim c++ syntax highlighting
Plugin 'octol/vim-cpp-enhanced-highlight'
let g:cpp_class_scope_highlight = 1

" Syntax checking direcltly in vim (display >> on the left)
Plugin 'scrooloose/syntastic'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
" see http://choorucode.com/2014/11/06/how-to-use-syntastic-plugin-for-vim/
let g:syntastic_check_on_open = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = "x"
let g:syntastic_warning_symbol = "!"

"Plugin 'Valloric/YouCompleteMe'
" Needs to run this after upgrade:
" cd ~/.vim/bundle/YouCompleteMe
" ./install.sh --clang-completer

" close braces and stuff
Plugin 'jiangmiao/auto-pairs'

Plugin 'scrooloose/nerdtree'
"autocmd VimEnter * NERDTree
autocmd BufEnter * NERDTreeMirror
" CTRL-t to toggle tree view with CTRL-t
nmap <silent> <C-t> :NERDTreeToggle<CR>
" Set F3 to put the cursor to the nerdtree
"nmap <silent> <F3> :NERDTreeFind<CR>

"Plugin 'jeffkreeftmeijer/vim-numbertoggle'
"let g:NumberToggleTrigger="<F2>"

Plugin 'rust-lang/rust.vim'
Plugin 'ebfe/vim-racer'
set hidden
let g:racer_cmd = "~/dev/racer/target/release/racer"
let $RUST_SRC_PATH="~/dev/rust-1.0.0/src"

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


syntax on
colorscheme ron
set smarttab
set autoindent
set number
set shiftwidth=4
set tabstop=4
set softtabstop=4
set incsearch
set hlsearch
set expandtab
set mouse=v
set wildmenu
set wildmode=list:longest,full
set guifont=Monospace\ 7

" wrap real lines into more managable visible lines
set wrap linebreak nolist

" enable pasting with middle mouse button
map <MiddleMouse> "*p

" use j and k in the middle of typing to switch lines
inoremap jj <ESC>gj
inoremap kk <ESC>gk

" use j and k to move between visible lines on the screen, not real lines
map j gj
map k gk

" enable syntax-based folds
set foldmethod=syntax
set foldlevelstart=20
" save/restore the folds of all the pretty files
au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

" execute these commands when some filetype is opened
autocmd FileType haskell map <F5> :w<CR>:!ghci "%"<CR>
autocmd FileType prolog map <F5> :w<CR>:!prolog "%"<CR>
autocmd FileType python map <F5> :w<CR>:!python "%"<CR>
autocmd FileType tex map <F5> :w<CR>:!make<CR><CR>
autocmd FileType sh map <F5> :w<CR>:!"%"<CR>
autocmd FileType cpp map <F5> :w<CR>:!make<CR>

" activate spellchecking for certain filetypes
autocmd Filetype tex setlocal spell spelllang=en_us
autocmd Filetype gitcommit setlocal spell spelllang=en_us
autocmd Filetype markdown setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us

" while opening a TeX-file, make VIM behave like it was a LaTeX file
let g:tex_flavor = "latex"

augroup cuda
	autocmd BufRead,BufNewFile *.cu set filetype=cpp
	autocmd BufRead,BufNewFile *.cuh set filetype=cpp
	autocmd BufRead,BufNewFile *.hpp set filetype=cpp
augroup END

" use ctrl-s to save while typing 
" ATTENTION: Needs some settings in .zshrc or .bashrc to ignore the Ctrl-S
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>
imap <c-s> <c-o><c-s>

" create matching delimiters
" vnoremap _( <Esc>`>a)<Esc>`<i(<Esc>
" vnoremap _[ <Esc>`>a]<Esc>`<i[<Esc>
" autocmd Filetype cpp inoremap ( ()<Esc>i
" autocmd Filetype cpp inoremap [ []<Esc>i
" autocmd Filetype cpp inoremap { {<CR>}<Esc>O<TAB>
" autocmd Filetype cpp autocmd Syntax html,vim inoremap < <lt>><Esc>i| inoremap > <c-r>=ClosePair('>')<CR>
" autocmd Filetype cpp inoremap ) <c-r>=ClosePair(')')<CR>
" autocmd Filetype cpp inoremap ] <c-r>=ClosePair(']')<CR>
" autocmd Filetype cpp inoremap } <c-r>=CloseBracket()<CR>
" autocmd Filetype cpp inoremap " <c-r>=QuoteDelim('"')<CR>
" autocmd Filetype cpp inoremap ' <c-r>=QuoteDelim("'")<CR>

" function ClosePair(char)
" 	if getline('.')[col('.') - 1] == a:char
" 		return "\<Right>"
" 	else
" 		return a:char
" 	endif
" endf

" function CloseBracket()
" 	if match(getline(line('.') + 1), '\s*}') < 0
" 		return "\<CR>}"
" 	else
" 		return "\<Esc>j0f}a"
" 	endif
" endf

" function QuoteDelim(char)
" 	let line = getline('.')
" 	let col = col('.')
" 	if line[col - 2] == "\\"
" 		"Inserting a quoted quotation mark into
" 		the string
" 		return a:char
" 	elseif line[col - 1] == a:char
" 		"Escaping out of the string
" 		return "\<Right>"
" 	else
" 		"Starting a string
" 		return a:char.a:char."\<Esc>i"
" 	endif
" endf