" --------------- Auto-install vim-plug if not detected ----------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" ------------------------------- PLUGINS ------------------------------------
Plug 'arecarn/vim-crunch'      " compute math expressions with g={motion}
Plug 'arecarn/vim-selection'   " required for vim-crunch
Plug 'FraserLee/vim-polyglot'  " languages, swap back to 'sheerun/vim-polyglot' if my PR is accepted
Plug 'github/copilot.vim'      " vim-copilot
Plug 'godlygeek/tabular'       " align stuff
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'kana/vim-submode'        " some more complex shortcuts, chord-style-ish
Plug 'mg979/vim-visual-multi'  " sublime-text style multi-cursors
Plug 'mhinz/vim-startify'      " list recently used when starting vim without a file
Plug 'morhetz/gruvbox'         " colourscheme
Plug 'preservim/nerdcommenter' " comment and uncomment
Plug 'tommcdo/vim-exchange'    " cx{motion} in normal or X in visual to swap stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'davepinto/virtual-column.nvim' " thinner colour column
Plug 'OmniSharp/omnisharp-vim'       " c# error/warning integration
Plug 'dense-analysis/ale'            " asynchronous linting
Plug 'neoclide/coc.nvim', {'branch': 'release'} " autocomplete (used sparingly)
Plug 'nvim-lua/plenary.nvim'         " needed for harpoon
Plug 'ThePrimeagen/harpoon'          " recently used files
Plug 'nvim-telescope/telescope.nvim' " run `:checkhealth telescope` after install
" ----------------------------------------------------------------------------
call plug#end()

" setup tree-sitter, virtual column
lua << EOF
require'nvim-treesitter.configs'.setup{ensure_installed = "maintained", highlight = {enable = true, additional_vim_regex_highlighting = true}}
require('virtual-column').init{column_number = 79, overlay=false, enabled=true,
    vert_char = '|' -- '┃', -- |-x-| ╳││|‖ ⎸┃¦   :-: ┆ │  ┆┆┊  │⎥ ⎢⎪ ┊ouoeu',
}
EOF
" ---------------------------- MAPPINGS --------------------------------------

" Space to <leader> for super convenient combos
nnoremap <SPACE> <Nop>
let mapleader=" "

" Unmap some keys I accidentally hit too much because of dvorak 
nnoremap <S-q> <Nop>
nnoremap <C-z> <Nop>

" Swap S and L to make dvorak easier
nnoremap s l
vnoremap s l
nnoremap S L
vnoremap S L
nnoremap l s
vnoremap l s
nnoremap L S
vnoremap L S

" Make up and down work within wrapped lines
nnoremap j           gj
nnoremap k           gk
vnoremap j           gj
vnoremap k           gk
nnoremap <Down>      gj
nnoremap <Up>        gk
vnoremap <Down>      gj
vnoremap <Up>        gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk

" A long line to test navigation within wrapping:
" lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

" remap U to redo
nnoremap U g+

" ------------------------- BASIC SHORTCUTS ---------------------------------

" allow ctrl-z in insert mode to correct the most recent spelling mistake
inoremap <C-z> <c-g>u<Esc>[s1z=`]a<c-g>u

" sort lines (case insensitive) with <leader>s
xnoremap <leader>s :sort i<CR>

" toggle normal comment
map <leader>/ <plug>NERDCommenterToggle 
" fancy comment (whatever that means given language and context)
map <leader>? <plug>NERDCommenterSexy 

" multi-cursor binds (for mac), <ctrl-j/k> to create up and down cursors
" C-n n n n to select a bunch of the same word, N goes backwards, q / Q skips one
let g:VM_maps = {} 
let g:VM_maps["Add Cursor Down"]   = '<C-j>'
let g:VM_maps["Add Cursor Up"]     = '<C-k>'

function! TabAlign(zs)
    " get the character under the cursor
    let c = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let pos = getpos(".") " save the position of the cursor
    " Tabularize with that character
    if a:zs | :execute ":Tabularize /" . c . "\\zs"
    else    | :execute ":Tabularize /" . c
    endif
    call setpos('.', pos) " Restore the cursor position
endfunction

" <leader>t will align stuff like
" aaaaaa | aaa | aaaaaa
" b      | b   | b
" while <leader>T will align stuff like
" aaaaaa,  aaa,  aaaaaa
" b,       b,    b
noremap <leader>t :call TabAlign(0)<cr>
noremap <leader>T :call TabAlign(1)<cr>

" <space>ff to search file-names, <space>fg to search file-content
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>gg <cmd>Telescope live_grep<cr>

" <space>ya to add the current file to a list, <space>yy to view the list
nnoremap <leader>ya <cmd>lua require('harpoon.mark').add_file()<cr>
nnoremap <leader>yy <cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>

" ---------------------------- BASIC SETUP -----------------------------------

se nu           " Turn on line numbers
se scrolloff=12 " Keep 12 lines of context around cursor
syntax on       " Turn on syntax highlighting (default in nvim)

" Fix backspace to work more rationally (crikey that's a strange default)
se backspace=indent,eol,start

" Set tabs to 4 spaces
se expandtab tabstop=4 shiftwidth=4 

" Wrap lines at current indent level, don't split words
se bri lbr 

" Set the colour-column to 80
se colorcolumn=80

" Don't wrap text when writing
se textwidth=0

" Search settings
se hlsearch   " Highlight search matches
se incsearch  " Display partial matches while searching
se ignorecase " Ignore case when searching...
se smartcase  " ...unless the search contains an uppercase letter 
              " (use /search\C to search case-sensitively)

" Turn on spellcheck, set languages, make uncapitalized text not an error
se spell spelllang=en_ca,ru spellcapcheck="" 

" Command completion with <tab>
se wildmenu
se wildmode=longest:full,full " First <tab> fills the longest common string, 
                              " further <tab>s cycle through matches 

" escape terminal with <esc>
tnoremap <Esc> <C-\><C-n>

" Don't automatically continue comments on <return> or with o/O
" (something in ftplugin is resetting this, needs to be bodged with an autocmd)
autocmd FileType * se formatoptions-=ro

" re-open files at the same line as closed
" (mkdir ~/.vim/view/ if it doesn't already exist)
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent! loadview 

" create folds based on indent-level, auto-open all when entering a file
autocmd BufEnter * ++nested se fdm=indent foldlevel=100
    " as an example, press 
    " "zc" over these lines 
    " to close, "zo" to open

" ---------------------- PLUGIN CONFIGURATION --------------------------------

" Markdown settings
let g:mkdp_command_for_global = 1 " Let :MarkdownPreview work on any file type 
let g:mkdp_markdown_css = expand('~/vimrc/markdown_style.css') 
                                    " use my own CSS file

" Evaluate math expressions with g={motion}
let g:crunch_result_type_append = 0

"A whole whack of default commenting settings
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims           = 1
let g:NERDCompactSexyComs       = 1
let g:NERDCommentEmptyLines     = 1
let g:NERDToggleCheckAllLines   = 1

" disable start-screen cow
let g:startify_custom_header    = []

" integrate harpoon with telescope
lua require('telescope').load_extension('harpoon')


" -------------------------- COLOUR SCHEME -----------------------------------


colorscheme gruvbox 
let g:gruvbox_contrast_dark = 'hard'
se background=dark

" set spelling highlighting to underscore
hi SpellBad cterm=underline 

" The default copilot colour is identical to comments in gruvbox,
" both 6 and 7 look alright in reduced modes, 102 is decent in full
hi CopilotSuggestion ctermfg=6

" Set the colourcolumn background to the background colour, foreground to some grey
execute "hi ColorColumn ctermbg=" . 
            \matchstr(execute('hi Normal'), 'ctermbg=\zs\S*')
hi ColorColumn ctermfg=239

" -------------------------- SUBMODES ----------------------------------------
             
let g:submode_timeout = 1 " timeout after 2 seconds
let g:submode_timeoutlen = 2000
" don't consume submode-leaving key
let g:submode_keep_leaving_key = 1

" <leader> plus a direction massively changes window size. Subsequent taps to
" that a direction change it by 1 (though space can be re-pressed for another
" large increment).
"
" s is also used in place of l
call submode#enter_with('window_resize', 'n', '', '<leader>h', ':exe "vertical resize " . (winwidth (0) * 4/3)<CR>')
call submode#enter_with('window_resize', 'n', '', '<leader>s', ':exe "vertical resize " . (winwidth (0) * 3/4)<CR>')
call submode#enter_with('window_resize', 'n', '', '<leader>j', ':exe          "resize " . (winheight(0) * 4/3)<CR>')
call submode#enter_with('window_resize', 'n', '', '<leader>k', ':exe          "resize " . (winheight(0) * 3/4)<CR>')
call submode#map       ('window_resize', 'n', '', 'h', '<C-w>>')
call submode#map       ('window_resize', 'n', '', 's', '<C-w><')
call submode#map       ('window_resize', 'n', '', 'j', '<C-w>+')
call submode#map       ('window_resize', 'n', '', 'k', '<C-w>-')

" ------------------------- FILETYPE JUNK ------------------------------------

" Fix not associating correctly by default
au BufRead,BufNewFile *.asm set ft=mips

" ------------- LINTING, OTHER LANGUAGE SPECIFIC IDE TYPE STUFF --------------

hi ALEError   ctermfg=Red  cterm=none
hi ALEWarning ctermfg=172  cterm=italic

let g:OmniSharp_highlighting = 0
let g:OmniSharp_server_use_mono = 1
let g:ale_linters = {
\ 'cs': ['OmniSharp'],
\ 'rust' : ['analyzer'],
\}

" trigger completion in insert mode with '.'
" TODO: disable dot only limitation when copilot is offline
call coc#config('suggest', { 'autoTrigger': 'trigger' })

call coc#config('coc.source.OmniSharp',     {'triggerCharacters': '.'})
call coc#config('coc.source.rust-analyzer', {'triggerCharacters': '.'})

" --------------- BASIC COMPILATION SHORTCUTS -------------------------------
" --------------------- *very much WIP* ------------------------------------
" <F4> runs the current file assuming it's standalone, <F5> assumes there's
" some language-specific makefile equivalent.
" 
" TODO: Fix to work with nvim 
" TODO: add more language type supports
" TODO: replace current terminal window instead of creating a new one if one
" exists
" TODO: auto-shift focus back away from terminal-window if input isn't required
" 
" modified majorly from https://stackoverflow.com/a/18296266/
" <F4>
autocmd filetype python nnoremap <F4> :w <bar> :vs <bar> te python3 "%:p"<CR>
autocmd filetype c      nnoremap <F4> :w <bar> :vert term ++shell gcc     "%:p" -o "%:p:r" && "%:p:r"<CR>
autocmd filetype cpp    nnoremap <F4> :w <bar> :vert term ++shell g++     "%:p" -o "%:p:r" && "%:p:r"<CR>
autocmd filetype rust   nnoremap <F4> :w <bar> :vert term ++shell rustc   "%:p" -o "%:p:r" && "%:p:r"<CR>
" <F5>
autocmd filetype rust   nnoremap <F5> :w <bar> :vs <bar> te cargo run<CR>
