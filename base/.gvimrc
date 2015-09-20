" use ghc functionality for haskell files
au Bufenter *.hs compiler ghc

" switch on syntax highlighting
syntax on

" enable filetype detection, plus loading of filetype plugins
filetype on
filetype indent on
filetype plugin on

autocmd FileType haskell :set expandtab tabstop=4 shiftwidth=4 softtabstop=4 retab 
autocmd FileType prolog :set expandtab tabstop=2 shiftwidth=2 softtabstop=2 

:set number

" configure browser for haskell_doc.vim
let g:haddock_browser = "/usr/bin/firefox"

let g:ghc = "/usr/bin/ghc6"
let g:haddock_docdir = "/usr/share/doc/ghc-doc/"
let g:haddock_indexfiledir = "~/.vim/"
