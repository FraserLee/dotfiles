set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
"--------------------------
Plugin 'valloric/youcompleteme'
Plugin 'morhetz/gruvbox'
Plugin 'preservim/nerdtree'
Plugin 'jdonaldson/vaxe'
Plugin 'kana/vim-submode'
Plugin 'preservim/nerdcommenter'
"--------------------------
call vundle#end()            " required
filetype plugin indent on    " required
filetype plugin on

"------------------BASIC SETUP---------------------
"Turn on line numbers, set up tabs to how I like them, turn on syntax highlighting
se nu
"se rnu
autocmd BufEnter * ++nested se noexpandtab tabstop=4
syntax on

"Fix backspace to work more rationally
set backspace=indent,eol,start

"Set spelling language
set spell spelllang=en_ca

"enable folds from indent, auto-open all when entering a file
autocmd BufEnter * ++nested se fdm=indent foldlevel=100

"Make ycm work a bit better with haxe
let g:vaxe_enable_ycm_defaults = 1
let g:vaxe_cache_server_autostart = 1

"--------------------COLOUR------------------------
"Sets the colour theme and turns on spelling highlighting to underscore
"whenever entering vim. If I don't do these two in one call, stuff resets
"weird.
autocmd vimenter * ++nested call SetColourStuff()
function SetColourStuff()
	colorscheme gruvbox 
	set background=dark
	hi SpellBad cterm=underline
endfunction
call SetColourStuff()

"-----------------MAPPING STUFF--------------------

"Swaps s and l to make dvorak work a wee bit better. For some reason a langmap
"messes with submodes, so I just remap em instead.
""set langmap=sl,ls,SL,LS
noremap s l
noremap l s
noremap S L
noremap L S

"Space to <leader> for super convinient combos
nnoremap <SPACE> <Nop>
let mapleader=" "

"----------------BASIC SHORTCUTS-------------------

"toggle nerdtree
nnoremap <leader>g :NERDTreeToggle<CR>
"open nerdtree on current file
nnoremap <leader>f :NERDTreeFind<CR>
"jump to definition
nnoremap <leader>t :YcmCompleter GoTo<CR>
"fix easy errors
nnoremap <leader>n :YcmCompleter FixIt<CR>
"toggle normal comment
map <leader>/ <plug>NERDCommenterToggle 
"fancy comment
map <leader>? <plug>NERDCommenterSexy 

"---------------COMPLEX SHORTCUTS-------------------
"----------(all done through submodes)--------------

let g:submode_timeout = 1
let g:submode_timeoutlen = 2000
" don't consume submode-leaving key
let g:submode_keep_leaving_key = 1

"g+ and g- (undo & redo) let you repeat hit + and -
"(also = works as + so you don't need to hit shift)
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#enter_with('undo/redo', 'n', '', 'g=', 'g+')
call submode#map('undo/redo', 'n', '', '-', 'g-')
call submode#map('undo/redo', 'n', '', '+', 'g+')
call submode#map('undo/redo', 'n', '', '=', 'g+')

"<leader> plus a direction massively changes window size. Subsequent taps to
"that a direction change it by 1 (though space can be re-pressed for another
"large increment)

"s is also used in place of l
call submode#enter_with('window_resize', 'n', '', '<leader>h', ':exe "vertical resize " . (winwidth(0) * 4/3)<CR>')
call submode#enter_with('window_resize', 'n', '', '<leader>s', ':exe "vertical resize " . (winwidth(0) * 3/4)<CR>')
call submode#map('window_resize', 'n', '', 'h', '<C-w>>')
call submode#map('window_resize', 'n', '', 's', '<C-w><')
call submode#enter_with('window_resize', 'n', '', '<leader>j', ':exe "resize " . (winheight(0) * 4/3)<CR>')
call submode#enter_with('window_resize', 'n', '', '<leader>k', ':exe "resize " . (winheight(0) * 3/4)<CR>')
call submode#map('window_resize', 'n', '', 'j', '<C-w>+')
call submode#map('window_resize', 'n', '', 'k', '<C-w>-')

"-------------------COMMENTING----------------------
"A whole whack of default settings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1
let g:NERDToggleCheckAllLines = 1
