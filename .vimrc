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
Plug 'sheerun/vim-polyglot'    " languages
Plug 'github/copilot.vim'      " vim-copilot
Plug 'godlygeek/tabular'       " align stuff
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'kana/vim-submode'        " some more complex shortcuts, chord-style-ish
Plug 'mg979/vim-visual-multi'  " sublime-text style multi-cursors
Plug 'mhinz/vim-startify'      " list recently used when starting vim without a file
Plug 'morhetz/gruvbox'         " colourscheme
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'preservim/nerdcommenter' " comment and uncomment
Plug 'tommcdo/vim-exchange'    " cx{motion} in normal or X in visual to swap stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-telescope/telescope.nvim'  " run `:checkhealth telescope` after install
Plug 'svban/YankAssassin.vim'  " move cursor back to where it was when yanked
Plug 'lervag/vimtex'           " latex auto-compilation (still needs config work)
Plug 'ChesleyTan/wordCount.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release', 'do' : ':CocUpdate'} " autocomplete (used sparingly)
Plug 'rodrigore/coc-tailwind-intellisense', {'do': 'npm install'}

Plug 'vimsence/vimsence'

Plug '~/ScratchPad'            " Plug 'fraserlee/ScratchPad'
Plug '~/Pinyin'                " Plug 'fraserlee/Pinyin'

Plug 'lukas-reineke/virt-column.nvim' " thinner colour column

Plug 'wellle/context.vim'

" Plug 'shaunsingh/oxocarbon.nvim', { 'do': './install.sh' }
" ----------------------------------------------------------------------------
call plug#end()

" setup tree-sitter, virtual column
lua << EOF
    require'nvim-treesitter.configs'.setup{
        ensure_installed = "all", 
        ignore_install = { "markdown" },
        highlight = {enable = true, additional_vim_regex_highlighting = true}
    }
    require('virt-column').setup{
        char = '|' -- '┃', -- |-x-| ╳││|‖ ⎸┃¦   :-: ┆ │  ┆┆┊  │⎥ ⎢⎪ ┊ouoeu',
    }
EOF
" ---------------------------- MAPPINGS --------------------------------------

" Space to <leader> for super convenient combos
noremap <SPACE> <Nop>
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

" <leader>y to yank to clipboard, <leader>p to paste from clipboard
noremap <leader>y "*y
noremap <leader>p "*p

" <leader>m to reformat the current paragraph, concatenating and splitting
" lines as necessary to fit 80 characters. <leader>w for the current line.
nnoremap <leader>m gqip
nnoremap <leader>w gqq

" multi-cursor binds (for mac), <ctrl-j/k> to create up and down cursors
" C-n n n n to select a bunch of the same word, N goes backwards, q / Q skips one
let g:VM_maps = {} 
let g:VM_maps["Add Cursor Down"]   = '<C-j>'
let g:VM_maps["Add Cursor Up"]     = '<C-k>'

function! TabAlign(zs)
    " get the character under the cursor
    let c = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let pos = getpos(".") " save the position of the cursor

    " if the character needs to be escaped, put a backslash in front of it
    " Todo: add more characters that need escaping
    if matchstr(c, '[\\\/]') != ''
        let c = '\' . c
    endif

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

" <space>cc to centre the current buffer with 80 width by opening a scratchpad
nnoremap <leader>cc <cmd>ScratchPad<cr>

" <space>cd to set the working directory to the current buffer's directory
nnoremap <leader>cd :cd %:p:h<cr>

" <space>.. to go up a directory
nnoremap <leader>.. :cd ..<cr>

" <space>gg to jump to the definition of the symbol under the cursor
nnoremap <leader>gg <cmd>call CocActionAsync('jumpDefinition')<cr>

" <space>fffff to ascii-artify the current line
nnoremap <leader>fffff <cmd>.!figlet<cr>

" <space>ct to toggle both cursorline and cursorcolumn to the opposite of what they are
function! ToggleCursorCross()
    " check current state (instead of just toggling variables individually,
    " this'll keep stuff in sync)
    if &cursorcolumn
        :set nocursorcolumn
        :set nocursorline
        :set nolazyredraw
    else
        :set cursorcolumn
        :set cursorline
        " partial redraw when cross is active, otherwise it's unusable slow
        " (this occasionally messes up and the screen is inaccurate until you
        " move, so not on by default)
        :set lazyredraw
    endif
endfunction

nnoremap <leader>ct :call ToggleCursorCross()<cr>



" Pinyin input.
let g:pinyin_keys=['d','h','t','n']

" ------------------------ LANGUAGE SHORTCUTS --------------------------------

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


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
se spell spelllang=en_ca,ru,fr spellcapcheck="" 

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

" setup latex stuff
let g:vimtex_view_method = 'skim'

let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \    '-shell-escape',
    \    '-verbose',
    \    '-file-line-error',
    \    '-synctex=1',
    \    '-interaction=nonstopmode',
    \ ],
\}

" word count
let g:wc_conservative_update = 1

" copilot
let g:copilot_filetypes = { 'markdown': 1, 'scratchpad': 1 }

" discord stuff. This is very dumb, but I really like it.
let g:vimsence_small_text = 'NeoVim'
let g:vimsence_small_image = 'neovim'
let g:vimsence_editing_details = 'Kinda neat that this'
let g:vimsence_editing_state   = 'is in discord, eh?'


" -------------------------- COLOUR SCHEME -----------------------------------

colorscheme gruvbox 
let g:gruvbox_contrast_dark = 'hard'
se background=dark
" se background=light
" colorscheme oxocarbon

" set spelling highlighting to underscore
hi SpellBad cterm=underline 

" The default copilot colour is identical to comments in gruvbox,
" both 6 and 7 look alright in reduced modes, 102 is decent in full
hi CopilotSuggestion ctermfg=6

" Set the colourcolumn background to the background colour, foreground to
" the same as the window split colour
execute "hi ColorColumn ctermbg=" . 
            \matchstr(execute('hi Normal'), 'ctermbg=\zs\S*')
hi! link VirtColumn VertSplit

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

" Toggle depending on if I'm working more with x86 or mips
au BufRead,BufNewFile *.asm set ft=asm
" au BufRead,BufNewFile *.asm set ft=mips

" ------------------------ STATUS LINE ---------------------------------------
" modified from https://unix.stackexchange.com/a/243667
" start of default statusline (trailing space)
set statusline=%f\ %h%w%m%r\ 

" current byte / bytes in file
" set statusline+=%#lite#\ %o/%{wordcount().bytes}

" word count (trailing space)
set statusline+=%=%{wordCount#WordCount()}\ words\ \ 

" end of default statusline (row, col, percentage)
set statusline+=%(%l,%c%V\ %=\ %P%)

" -------- LINTING, COMPLETION, OTHER LANGUAGE SPECIFIC IDE TYPE STUFF -------

let g:coc_global_extensions = [ 'coc-cmake', 'coc-css', 'coc-clangd', 
 \ 'coc-dlang', 'coc-glslx', 'coc-go', 'coc-go', 
 \ 'coc-godot', 'coc-htmldjango', 'coc-java', 'coc-jedi', 'coc-json', 
 \ 'coc-rust-analyzer', 'coc-sh', 'coc-sumneko-lua', 'coc-svg', 'coc-texlab', 
 \ 'coc-toml', 'coc-tsserver', 'coc-vetur', 'coc-yaml', 'coc-zig', ]

call coc#config('sumneko-lua.enableNvimLuaDev', 1)


" trigger completion in insert mode with '.'
" TODO: disable dot only limitation when copilot is offline
call coc#config('suggest', { 'autoTrigger': 'trigger' })
call coc#config('signature', {'enable': 0})

" Don't auto-close html tags
" call coc#config('html.autoCloseTags', 0 )

" Set the language of .html.tera files as html
autocmd BufNewFile,BufRead *.html.tera set filetype=html

" --------------- BASIC COMPILATION SHORTCUTS --------------------------------
" --------------------- *very much WIP* --------------------------------------
" <F4> runs the current file assuming it's standalone, <F5> assumes there's
" some language-specific makefile equivalent.
" 
" TODO: add more language type supports
" TODO: replace current terminal window instead of creating a new one if one
" exists
" TODO: auto-shift focus back away from terminal-window if input isn't required
" 
" modified majorly from https://stackoverflow.com/a/18296266/
" <F4>
autocmd filetype python nnoremap <F4> :w <bar> :vs <bar> te python3 "%:p"<CR>
autocmd filetype c      nnoremap <F4> :w <bar> :vs <bar> te gcc     "%:p" -o "%:p:r" && "%:p:r"<CR>
autocmd filetype cpp    nnoremap <F4> :w <bar> :vs <bar> te g++     "%:p" -std=c++17 -o "%:p:r" && "%:p:r"<CR>
autocmd filetype rust   nnoremap <F4> :w <bar> :vs <bar> te rustc   "%:p" -o "%:p:r" && "%:p:r"<CR>
" <F5>
autocmd filetype rust   nnoremap <F5> :w <bar> :vs <bar> te cargo run<CR>

                   
"                                                            _  __      ____ _ 
"                                                           (_) \ \ /\ / / _` |
"                                                            _   \ V  V / (_| |
"                                                           (_)   \_/\_/ \__, |
"                                                                           |_|
