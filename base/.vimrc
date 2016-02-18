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
" see further below the setting of commentstring

" clipboard (i.e. over multiple instances of vim)
" Plugin 'svermeulen/vim-easyclip'

"" Git diff status on the left side
"Plugin 'airblade/vim-gitgutter'

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

" https://github.com/easymotion/vim-easymotion
" move fast with \\w
" find fast with \\f
Plugin 'easymotion/vim-easymotion'
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)")

" https://github.com/ntpeters/vim-better-whitespace
" :ToggleWhitespace
" :StripWhitespace
Plugin 'ntpeters/vim-better-whitespace'
autocmd VimEnter * :hi ExtraWhiteSpace ctermbg=52
"autocmd VimEnter * :hi ExtraWhiteSpace ctermbg=88
"autocmd VimEnter * :hi ExtraWhiteSpace ctermbg=124

" https://github.com/nathanaelkane/vim-indent-guides
" http://vim.wikia.com/wiki/Xterm256_color_names_for_console_Vim
" indentation is colored for better visibility
Plugin 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=233 ctermbg=233
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=232 ctermbg=232
autocmd Vimenter * :IndentGuidesEnable

Plugin 'elixir-lang/vim-elixir'
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
set laststatus=2 "always show the status line"
"set list "needed to make listchars possible
"set listchars=tab:\|\·   "display tabs as |···"
set history=5000

" wrap real lines into more managable visible lines
set wrap linebreak

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

augroup cuda
	autocmd BufRead,BufNewFile *.cu set filetype=cpp
	autocmd BufRead,BufNewFile *.cuh set filetype=cpp
	autocmd BufRead,BufNewFile *.hpp set filetype=cpp
augroup END

" execute these commands when some filetype is opened
autocmd FileType haskell map <F5> :w<CR>:!ghci "%"<CR>
autocmd FileType prolog map <F5> :w<CR>:!prolog "%"<CR>
autocmd FileType python map <F5> :w<CR>:!python "%"<CR>
autocmd FileType tex map <F5> :w<CR>:!make<CR><CR>
autocmd FileType sh map <F5> :w<CR>:!"%"<CR>
autocmd FileType cpp map <F5> :w<CR>:!make<CR>
autocmd FileType cpp set commentstring=//\ %s
autocmd FileType cmake set commentstring=#\ %s
autocmd BufRead,BufNewFile *.p map <F5> :w<CR>:!gnuplot "%"<CR>

" activate spellchecking for certain filetypes
autocmd Filetype tex setlocal spell spelllang=en_us
autocmd Filetype gitcommit setlocal spell spelllang=en_us
autocmd Filetype markdown setlocal spell spelllang=en_us
autocmd BufRead,BufNewFile *.txt setlocal spell spelllang=en_us

" while opening a TeX-file, make VIM behave like it was a LaTeX file
let g:tex_flavor = "latex"

" use ctrl-s to save while typing
" ATTENTION: Needs some settings in .zshrc or .bashrc to ignore the Ctrl-S
" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
nnoremap <silent> <C-S> :if expand("%") == ""<CR>browse confirm w<CR>else<CR>confirm w<CR>endif<CR>
imap <c-s> <c-o><c-s>


set guifont=Hack
