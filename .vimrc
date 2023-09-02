" --------------- Auto-install vim-plug if not detected ----------------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" ------------------------------- PLUGINS ------------------------------------

Plug 'godlygeek/tabular'        " align stuff
Plug 'kana/vim-submode'         " some more complex shortcuts, chord-style-ish
Plug 'lukas-reineke/virt-column.nvim' " thinner colour column
Plug 'mg979/vim-visual-multi'   " sublime-text style multi-cursors
Plug 'mhinz/vim-startify'       " list recently used when starting vim without a file
Plug 'numToStr/Comment.nvim'    " easier commenting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'nvim-treesitter/nvim-treesitter-context' " see context within large scope blocks (needs fast-ish terminal)
Plug 'svban/YankAssassin.vim'   " move cursor back to where it was after a yank
Plug 'tommcdo/vim-exchange'     " cx{motion} in normal or X in visual to swap stuff
Plug 'PHSix/faster.nvim'        " better acceleration for j/k
" Plug 'tpope/vim-sleuth'         " automatically detect indentation
Plug 'jansedivy/jai.vim'
Plug 'abhishekmukherg/xonsh-vim'
Plug 'echasnovski/mini.indentscope', { 'branch': 'stable' }
Plug 'mrshmllow/document-color'

" AI stuff
Plug 'github/copilot.vim'       " vim-copilot
Plug 'madox2/vim-ai'

Plug 'neovim/nvim-lspconfig'
" Plug 'simrat39/rust-tools.nvim' " this is way overkill, I really only want COC-style inline type-info.
" Plug 'mrcjkb/haskell-tools.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'

Plug 'nvim-lua/plenary.nvim'    " required for telescope
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x', 'do': ':!brew install ripgrep' }


Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-calc'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'

" Plug '~/Pinyin'                 " Plug 'fraserlee/Pinyin'
Plug '~/ScratchPad'             " Plug 'fraserlee/ScratchPad'

" colourscheme
Plug 'morhetz/gruvbox'
Plug 'jamespwilliams/bat.vim'
Plug 'sickill/vim-monokai'
Plug 'ayu-theme/ayu-vim'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'shaunsingh/oxocarbon.nvim'
" Plug 'chriskempson/base16-vim'
Plug 'hardselius/warlock'

" ----------------------------------------------------------------------------
call plug#end()

" setup a whole bunch of lua stuff
lua << EOF
    require'nvim-treesitter.configs'.setup{
        ensure_installed = "all",

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            disable = function(lang, bufnr)
                -- When opening a markdown file with more than ~700 lines (at least on this laptop),
                -- Treesitter syntax highlighting and a word-count in the statusline are both
                -- excruciatingly slow (though, admittedly, I'm pretty sensitive to this -
                -- typing speed being the reason I ditched an IDE in the first place).
                if lang == "markdown" and vim.api.nvim_buf_line_count(bufnr) > 1200 then
                    -- possibly mess with the statusline here?

                    -- link `markdownError` syntax group to normal, since that gets thrown
                    -- incorrectly by vim's default markdown syntax

                    vim.cmd('hi link markdownError Normal')

                    return true
                end
                return false
            end
        },

        incremental_selection = {
            enable = true,
            keymaps = {
                -- <enter> to select and expand selection via syntax
                -- <shift+enter> to shrink and deselect
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<S-CR>',
            },
            disable = function(lang, bufnr)
                if lang == "markdown" and vim.api.nvim_buf_line_count(bufnr) > 1200 then
                    return true
                end
                return false
            end
        },
    }
    require'treesitter-context'.setup{
        patterns = { default = { 'class', 'function', 'method', 'for', 'while', 'if', 'switch', 'case', }, },
        separator = '-',
    }
    require('virt-column').setup{
        char = '│', -- | ┃ |-x-| ╳││|‖ ⎸┃¦   :-: ┆ │  ┆┆┊  │⎥ ⎢⎪ ┊ouoeu',
    }

    require('mini.indentscope').setup()

    require("mason").setup()
    require("mason-lspconfig").setup{
        -- automatic_installation = true,
        automatic_installation = false,
    }
    require("Comment").setup{
        mappings = false, -- suppress default mappings
    }

    require('document-color').setup{
        mode = 'background',
    }





    -- nvim-cmp configuration
    local cmp = require'cmp'

    cmp.setup({

        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        mapping = cmp.mapping.preset.insert({
            ['<C-j>'] = cmp.mapping.scroll_docs(4),
            ['<C-k>'] = cmp.mapping.scroll_docs(-4),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
        }),

        sources = cmp.config.sources({
            { name = 'calc' },
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'emoji' },
            { name = 'path' },
            -- 3 chars min before resorting to simple text-matching
            { name = 'buffer', keyword_length = 3 },
        })
    })

    -- mostly disable on markdown
    cmp.setup.filetype('markdown', {
        sources = cmp.config.sources({
            { name = 'calc' },
            { name = 'emoji' },
            { name = 'path' },
        })
    })

    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    capabilities.textDocument.colorProvider = { dynamicRegistration = true, }


    -- configure LSP stuff

    local on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        -- <leader>rn to rename current symbol
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        -- <leader>gg to jump to the definition of the current symbol
        vim.keymap.set('n', '<leader>gg', vim.lsp.buf.definition, bufopts)
        -- K to hover some documentation for the current symbol
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        -- F to open a floating window with any inline diagnostics
        vim.keymap.set('n', 'F', vim.diagnostic.open_float, bufopts)
    end


    local lsp = require("lspconfig")

    for _, server in ipairs({

        "arduino_language_server", "asm_lsp", "bashls", "clangd", "csharp_ls",
        "omnisharp", "clangd", "cmake", "cssls", "cssmodules_ls", "diagnosticls",
        "elixirls", "fortls", "golangci_lint_ls", "gopls", "graphql", "groovyls",
        "html", "haxe_language_server", "jsonls",
        -- "jdtls",
        -- "java_language_server",
        "quick_lint_js",
        "prismals", "tsserver", "kotlin_language_server", "texlab", "lua_ls",
        "nimls", "ocamllsp", "pyright", "sqlls", "svelte", "taplo",
        -- "tailwindcss", 
        "terraformls", "tflint", "tsserver", "vimls", "volar",
        "elmls",
        "rust_analyzer",
        "hls",
        "vuels", "lemminx", "yamlls", "zls", "rust_analyzer",

    }) do
        lsp[server].setup{
            on_attach = on_attach,
            capabilities = capabilities
        }
    end

    lsp["tailwindcss"].setup{
        on_attach = function(client, bufnr)
            if client.server_capabilities.colorProvider then
                require("document-color").buf_attach(bufnr)
            end
            on_attach(client, bufnr)
        end,
        capabilities = capabilities,
    }

    -- require("rust-tools").setup{ server = {
    --     on_attach = on_attach,
    --     capabilities = capabilities
    -- } }

    -- require('haskell-tools').setup {
    --   hls = {
    --     on_attach = on_attach,
    --     capabilities = capabilities
    -- } }


EOF
" ---------------------------- MAPPINGS --------------------------------------

" Space to <leader> for super convenient combos
noremap <SPACE> <Nop>
let mapleader=" "

" Unmap some keys I accidentally hit too much because of dvorak
nnoremap <S-q> <Nop>
nnoremap <C-z> <Nop>

" Make up and down work within wrapped lines (gj and gk) with
" acceleration (the plugin). In insert and visual, jk works within wrapped lines
" while <up> and <down> respect line-numbers. In normal mode, <up> and <down>
" also work within wrapped lines.

nnoremap j           <Plug>(faster_move_gj)
nnoremap k           <Plug>(faster_move_gk)
vnoremap j gj
vnoremap k gk
nnoremap <Down>      <Plug>(faster_move_j)
nnoremap <Up>        <Plug>(faster_move_k)
inoremap <Down> <C-o><Plug>(faster_move_gj)
inoremap <Up>   <C-o><Plug>(faster_move_gk)

" A long line to test navigation within wrapping:
" lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

" remap U to redo
nnoremap U g+

" map <esc> in normal mode to close help windows and clear search highlights
nnoremap <silent> <esc> :noh<CR> :helpclose<CR>

" ------------------------- BASIC SHORTCUTS ---------------------------------

" note to self (since I've had to google this multiple times): ctrl+o doesn't
" really work between files if you've used motions to navigate between files.
" Use ctrl+t instead.

" allow <ctrl>z in insert mode to correct the most recent spelling mistake
inoremap <C-z> <c-g>u<Esc>[s1z=`]a<c-g>u

" toggle normal comment
nmap <leader>/ <Plug>(comment_toggle_linewise_current)
vmap <leader>/ <Plug>(comment_toggle_linewise_visual)

" toggle block comment
nmap <leader>? <Plug>(comment_toggle_blockwise_current)
vmap <leader>? <Plug>(comment_toggle_blockwise_visual)


" sort lines (case insensitive) with <leader>s
xnoremap <leader>s :sort i<CR>

" <leader>y to yank to clipboard, <leader>p to paste from clipboard
noremap <leader>y "*y
noremap <leader>p "*p

" <leader>m to reformat the current paragraph, concatenating and splitting
" lines as necessary to fit 80 characters. <leader>h for the current line.
nnoremap <leader>m gqip
nnoremap <leader>h gqq

" <leader>S to remove all trailing whitespace from the current buffer
nnoremap <leader>S :%s/\s\+$//e<CR>

" multi-cursor binds (for mac), <ctrl>j/k to create up and down cursors
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
    if matchstr(c, '[\\\/\.]') != ''
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

" <space>fffff to ascii-artify the current line
nnoremap <leader>FFFFF <cmd>.!figlet<cr>

" <space>ct to toggle both cursorline and cursorcolumn to create a cool cross-hair
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

" ensure default lazyredraw is off
set nolazyredraw


" Find using Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope old_files<cr>


" ---------------------------- BASIC SETUP -----------------------------------

se nu           " Turn on line numbers
se rnu          " Disable this on a slower terminal (mac default, etc)
                " since it creates a lot of latency moving around

se scrolloff=10 " Keep some lines of context around cursor

syntax on       " Turn on syntax highlighting (default in nvim)

" Fix backspace to work more rationally (crikey that's a strange default)
se backspace=indent,eol,start

" Set tabs to 4 spaces
se expandtab tabstop=4 shiftwidth=4

" Wrap lines at current indent level, don't split words
se bri lbr

" Set the colour-column to fit 80 characters
se colorcolumn=81

" Don't wrap text when writing
se textwidth=0

" Search settings
se hlsearch   " Highlight search matches
se incsearch  " Display partial matches while searching
se ignorecase " Ignore case when searching...
se smartcase  " ...unless the search contains an uppercase letter
              " (use /search\C to search case-sensitively)

" Turn on spellcheck, set languages, make uncapitalized text not an error
se spell spelllang=en_ca,ru,fr,cjk spellcapcheck=""

" Command completion with <tab>
se wildmenu
se wildmode=longest:full,full " First <tab> fills the longest common string,
                              " further <tab>s cycle through matches

set undofile
set undodir=~/.vim/undodir

" escape terminal with <esc>
tnoremap <Esc> <C-\><C-n>

" Don't automatically continue comments on <return> or with o/O
" (something in ftplugin is resetting this, needs to be bodged with an autocmd)
autocmd FileType * se formatoptions-=ro

" re-open files at the same line as closed
" (mkdir ~/.vim/view/ if it doesn't already exist)
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent! loadview

" create folds based on syntax
" (zc / zC to close folds, zo / zO to open)
autocmd BufEnter * ++nested se foldlevel=100 foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

" fix issue with autoread not working in neovide
autocmd FocusGained * checktime


" ---------------------- PLUGIN CONFIGURATION --------------------------------

" Pinyin input.
let g:pinyin_keys=['d','h','t','n']

" Evaluate math expressions with g={motion}
let g:crunch_result_type_append = 0

" disable start-screen cow
let g:startify_custom_header    = []

" copilot
let g:copilot_filetypes = { 'markdown': 1, 'scratchpad': 1, 'prisma': 1, 'zen' : 1, '' : 1 }

" (disabled for the moment)
" " discord stuff. This is very dumb, but I really like it.
" let g:vimsence_small_text = 'NeoVim'
" let g:vimsence_small_image = 'neovim'
" let g:vimsence_editing_details = 'Kinda neat that this'
" let g:vimsence_editing_state   = 'is in discord, eh?'


" ocaml slight config thing
set rtp^="/Users/fraser/.opam/default/share/ocp-indent/vim"

" -------------------------- COLOUR SCHEME -----------------------------------

se background=dark
" se background=light

se termguicolors

let g:gruvbox_contrast_dark = 'hard'
let ayucolor="dark"

" colorscheme gruvbox

colorscheme ayu

" colorscheme oxocarbon

" colorscheme base16-black-metal-mayhem
" colorscheme base16-grayscale-dark
" colorscheme base16-horizon-dark

" colorscheme monokai
" colorscheme bat
" hi Normal guibg=NONE ctermbg=NONE


" set spelling highlighting to underscore, no text colour
hi clear SpellBad
hi SpellBad cterm=underline gui=underline

" The default copilot colour is identical to comments in gruvbox - hard to
" read. Both 6 and 7 look alright in reduced modes, 102 is decent in full.
hi CopilotSuggestion ctermfg=6 guifg=#00ffff

" map all nvim-cmp colours to normal text
hi link CmpItemAbbr normal
hi link CmpItemAbbrMatch normal
hi link CmpItemKind normal
hi link CmpItemMenu normal

" map scope line to comment
hi link MiniIndentscopeSymbol Comment

" I have vim setup with a few visual demarcations around the editable area.
" - ColourColumn: a vertical line at 81 characters
" - LineNR: the line numbers
" - VertSplit: the vertical line between the two panes
" - TreesitterContext: the horizontal line between scope context and the rest
"                      if the start of the scope is off-screen
"
" I want these all to have the same background colour as normal text, and the
" same foreground colour as LineNR.
let g:c_background_colour = matchstr(execute('hi Normal'), 'ctermbg=\zs\S*')
let g:g_background_colour = matchstr(execute('hi Normal'), 'guibg=\zs\S*')
let g:c_line_nr_colour = matchstr(execute('hi LineNR'), 'ctermfg=\zs\S*')
let g:g_line_nr_colour = matchstr(execute('hi LineNR'), 'guifg=\zs\S*')
if g:c_background_colour != ''
    execute "hi ColorColumn ctermbg="       . g:c_background_colour
    execute "hi LineNR ctermbg="            . g:c_background_colour
    execute "hi VertSplit ctermbg="         . g:c_background_colour
    execute "hi TreesitterContext ctermbg=" . g:c_background_colour
endif
if g:g_background_colour != ''
    execute "hi ColorColumn guibg="       . g:g_background_colour
    execute "hi LineNR guibg="            . g:g_background_colour
    execute "hi VertSplit guibg="         . g:g_background_colour
    execute "hi TreesitterContext guibg=" . g:g_background_colour
endif
if g:c_line_nr_colour != ''
    execute "hi ColorColumn ctermfg="       . g:c_line_nr_colour
    execute "hi VertSplit ctermfg="         . g:c_line_nr_colour
    execute "hi TreesitterContext ctermfg=" . g:c_line_nr_colour
endif
if g:g_line_nr_colour != ''
    execute "hi ColorColumn guifg="       . g:g_line_nr_colour
    execute "hi VertSplit guifg="         . g:g_line_nr_colour
    execute "hi TreesitterContext guifg=" . g:g_line_nr_colour
endif


hi! link VirtColumn ColorColumn
hi clear FloatBorder

hi! link markdownItalic Normal


" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

nnoremap <c-s> :call SynStack()<cr>

" -------------------------- SUBMODES ----------------------------------------

let g:submode_timeout = 1 " timeout after 2 seconds
let g:submode_timeoutlen = 2000

" don't consume submode-leaving key
let g:submode_keep_leaving_key = 1

" <leader>w enters a submode to resize the current window. From there, hjkl
" will resize things.
call submode#enter_with('window_resize', 'n', '', '<leader>w')
call submode#map       ('window_resize', 'n', '', 'h', '2<C-w>>')
call submode#map       ('window_resize', 'n', '', 'l', '2<C-w><')
call submode#map       ('window_resize', 'n', '', 'j', '2<C-w>+')
call submode#map       ('window_resize', 'n', '', 'k', '2<C-w>-')

" ------------------------- FILETYPE JUNK ------------------------------------

" Toggle depending on if I'm working more with x86 or mips
au BufRead,BufNewFile *.asm set ft=asm
" au BufRead,BufNewFile *.asm set ft=mips

" Prisma filetype
au BufRead,BufNewFile *.prisma set ft=prisma

" Dungeon filetype
au BufRead,BufNewFile *.dn set ft=markdown

" ---------------------------- WRITE CENTRED LINE ------------------------------
" I really like a certain style of comment where, from the cursor's position,
" a number of dashes are written to fill up to 80 characters, with some phrase
" centred in the middle. This is a function to do that.

lua << EOF
    function _G.write_centred_line( text )
        local c = vim.fn.col('.')
        local line = vim.fn.getline('.')

        -- make the text either an empty string, or pad it with spaces
        text = (text == nil or text == '') and '' or ' ' .. text .. ' '
        -- if the line doesn't end in a space, add one
        if line:sub(-1) ~= ' ' and line:len() > 0 then
            line = line .. ' '
        end

        local line_length = string.len(line)
        local dash_length = 80 - line_length

        local left = math.floor(dash_length / 2) - math.floor(string.len(text) / 2)
        local right = dash_length - left - string.len(text)

        local new_line = line .. string.rep('-', left) .. text .. string.rep('-', right)
        vim.fn.setline('.', new_line)
        vim.fn.col(c) -- restore cursor position
    end
EOF

function! WriteCentredLine()
    let text = input('Comment Text: ')
    execute ':lua write_centred_line("' . text . '")'
endfunction

" <leader>l in normal mode, <ctrl>l in insert mode
nnoremap <leader>l :call WriteCentredLine()<CR>
inoremap <c-l> <c-\><c-o>:call WriteCentredLine()<CR>


" -------- LINTING, COMPLETION, OTHER LANGUAGE SPECIFIC IDE TYPE STUFF -------

" Set the language of .html.tera files as html
autocmd BufNewFile,BufRead *.html.tera set filetype=html

" wgsl filetype
autocmd BufNewFile,BufRead *.wgsl set filetype=wgsl

" Set filetype to haskell and disable lsp for .zen files
autocmd BufNewFile,BufRead *.zen set filetype=haskell | LspStop



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
