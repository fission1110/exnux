call pathogen#infect()
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set mouse=          " disable mouse support
set showcmd		    " Show (partial) command in status line.
set synmaxcol=600   " Don't syntax highlight long lines.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set nowrap	"Don't wrap long lines
set hidden	"Hide edited buffers rather than quit them
set termguicolors
set listchars=tab:»·,trail:·,nbsp:␣,extends:»,precedes:«,eol:↲
set list
let g:terminal_scrollback_buffer_size = 100000 "Increase terminal scrollback buffer size
colorscheme terafox
syntax on

set clipboard+=unnamedplus " copy to system clipboard

set smartindent	"When creating a new line in a block it will put the cursor in the correct place
set autoindent	"When creating a new line in a block it will put the cursor in the correct place

" Try to auto detect and use the indentation of a file when opened.
autocmd BufRead * DetectIndent

" Otherwise use file type specific indentation. E.g. tabs for Makefiles
" and 4 spaces for Python. This is optional.
filetype plugin indent on

" Set a fallback here in case detection fails and there is no file type
" plugin available. You can also omit this, then Vim defaults to tabs.
set expandtab shiftwidth=4 softtabstop=4

" You stay in control of your tabstop setting.
set tabstop=4

filetype plugin on

" Set scroll offset to 5 lines
set scrolloff=5

let mapleader=" " "Set the leader key

set relativenumber
set nu "Show line numbers
set fileencodings=utf-8 "Force utf8

"stop stupid .swp files from showing up ever. If you need them, they're in
"~/.cache/swp
set backupdir=/home/$USERNAME/.cache/nvim/swp//,.
set directory=/home/$USERNAME/.cache/nvim/swp//,.

" persistent undo
set undodir=/home/$USERNAME/.cache/nvim/undo
set undofile

" Remap redraw to <leader>r
nmap <leader>r <cmd>redraw!<CR>jk

" Semi colon aliased to :
nnoremap ; :

"Go back and go forward
nnoremap { <C-O>
nnoremap } <C-i>

"w!! will now sudo write the file
cmap w!! SudaWrite

" Easily jump around windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Easily resize windows
" Resize with alt + hjkl instead of ctrl + w + hjkl
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>

" Easily move up and down pages
" Use alt + u and alt + d to move up and down pages
nnoremap <M-u> <C-u>
nnoremap <M-d> <C-d>

" python uses 4 spaces (PEP8) expandtab
au FileType python setlocal ts=4 sw=4 smartindent expandtab
" php is tabs
au FileType php setlocal ts=4 sw=4 smartindent autoindent noexpandtab

"Set ft=messages when file is called messages
autocmd BufNewFile,BufReadPost *messages* :set filetype=messages

" Use systags with c
autocmd  FileType  c setlocal tags+=~/.config/nvim/ctags/systags

"#############Nerdtree stuff#############
autocmd VimEnter * NERDTree | wincmd p
let g:NERDTreeWinSize = 25
let g:NERDTreeWinPos = "left"
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" HEX MODE!!
nmap <leader>hh <cmd>%!xxd<cr>
nmap <leader>hu <cmd>%!xxd -r<cr>

"turn on javascript snippets in typescript files
au BufRead,BufNewFile *.ts set ft=typescript.javascript

au FileType typescript set ts=2 sw=2 expandtab
au FileType html set ts=2 sw=2 expandtab

au FileType javascript set ts=4 sw=4 noexpandtab
au FileType php set ts=4 sw=4 noexpandtab

"turn on html snippets in php files
au BufRead *.php set ft=php
au BufNewFile *.php set ft=php

"turn on html snippets in cake template files
au BufRead *.ctp set ft=php.html
au BufNewFile *.ctp set ft=php.html

inoremap <C-l> <C-x><C-o>

let g:vdebug_options = {
\    "port" : 9000,
\    "server" : '',
\    "timeout" : 60,
\    "on_close" : 'detach',
\    "break_on_open" : 0,
\    "ide_key" : '',
\    "path_maps" : {'/code' : '/home/$USERNAME/code'},
\    "debug_window_level" : 0,
\    "debug_file_level" : 0,
\    "continuous_mode" : 1,
\    "debug_file" : "",
\    "watch_window_style" : 'expanded',
\    "marker_default" : '⬦',
\    "marker_closed_tree" : '▸',
\    "marker_open_tree" : '▾'
\}
let g:vdebug_keymap = {
\    "run" : "<F5>",
\    "run_to_cursor" : "<Enter>",
\    "step_over" : "<Down>",
\    "step_into" : "<Right>",
\    "step_out" : "<Left>",
\    "close" : "<ESC>",
\    "detach" : "q",
\    "set_breakpoint" : "<leader>m",
\    "get_context" : "<F11>",
\    "eval_under_cursor" : "<F12>",
\    "eval_visual" : "<Leader>ee",
\}
let g:vdebug_features = {'max_depth': 10}


"#############Python Stuff#############
hi Normal ctermbg=NONE guibg=NONE
hi NormalNC ctermbg=NONE guibg=NONE
hi StatusLine ctermbg=NONE guibg=NONE
hi StatusLineNC ctermbg=NONE guibg=NONE

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Change the color of the split line
highlight VertSplit guifg=#587b7b

"change the statusline highlighted background color to black
"
command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
" Set font on start
let g:Guifont="DejaVu Sans Mono for Powerline:h13"

" disable the online shortcut because it conflicts with <C-h> (move to left window)
let g:php_manual_online_search_shortcut=''


" ESC sends <ESC> key to terminal (good for nested vim). Press ESC ESC to
" really escape.
tnoremap <ESC><ESC> <C-\><C-n>
tnoremap <ESC> <ESC>

" no line numbers in terminal
autocmd TermOpen * setlocal nonumber norelativenumber

tnoremap <C-h> <C-\><C-n><C-w><C-h>
tnoremap <C-j> <C-\><C-n><C-w><C-j>
tnoremap <C-k> <C-\><C-n><C-w><C-k>
tnoremap <C-l> <C-\><C-n><C-w><C-l>
tnoremap <C-l><C-l> <C-\><C-n><C-w><C-l>
tnoremap <C-l> <C-l>

:au BufEnter * if &buftype == 'terminal' | :startinsert | endif

" <leader>ti/<leader>ts to terminal split, somewhat matching nerdtree
set splitright
set splitbelow
tnoremap <silent> <leader>ti <C-\><C-n>:execute "split sp \| term"<cr>
tnoremap <silent> <leader>ts <C-\><C-n>:execute "vert sp \| term"<cr>
nnoremap <silent> <leader>ti :execute "split sp \| term"<cr>
nnoremap <silent> <leader>ts :execute "vert sp \| term"<cr>
tnoremap <silent> <leader>tt :tabnew term:///$SHELL<cr>
nnoremap <silent> <leader>tt :tabnew term://$SHELL<cr>

nmap <leader>s <cmd>Scratch<cr>
let g:scratch_persistence_file="/tmp/nvim_scratch_persistance"

" Auto decompile java .class files
augr class
au!
au bufreadpost,filereadpost *.class %!/usr/local/bin/procyon %
au bufreadpost,filereadpost *.class set readonly
au bufreadpost,filereadpost *.class set ft=java
au bufreadpost,filereadpost *.class normal gg=G
au bufreadpost,filereadpost *.class set nomodified
augr END

" Auto decompile wasm files to pseudocode. (note: could also use wasm2c but
" that's uglier)
augr wasm
au!
au bufreadpost,filereadpost *.wasm %!/usr/local/bin/wasm-decompile %
au bufreadpost,filereadpost *.wasm set readonly
au bufreadpost,filereadpost *.wasm set ft=c
au bufreadpost,filereadpost *.wasm set nomodified
augr END

augr *.pyc
au!
au bufreadpost,filereadpost *.pyc %!/usr/local/bin/decompyle3 %
au bufreadpost,filereadpost *.pyc set readonly
au bufreadpost,filereadpost *.pyc set ft=python
au bufreadpost,filereadpost *.pyc set nomodified
augr END

augr *.pyo
au!
au bufreadpost,filereadpost *.pyo %!/usr/local/bin/decompyle3 %
au bufreadpost,filereadpost *.pyo set readonly
au bufreadpost,filereadpost *.pyo set ft=python
au bufreadpost,filereadpost *.pyo set nomodified
augr END

augr *.pyd
au!
au bufreadpost,filereadpost *.pyd %!/usr/local/bin/decompyle3 %
au bufreadpost,filereadpost *.pyd set readonly
au bufreadpost,filereadpost *.pyd set ft=python
au bufreadpost,filereadpost *.pyd set nomodified
augr END

augr *.jp{e}g
au!
au bufreadpost,filereadpost *.jpg %!/usr/bin/exiftool %
au bufreadpost,filereadpost *.jpg set readonly
au bufreadpost,filereadpost *.jpg set ft=config
au bufreadpost,filereadpost *.jpg set nomodified
au bufreadpost,filereadpost *.jpeg %!/usr/bin/exiftool %
au bufreadpost,filereadpost *.jpeg set readonly
au bufreadpost,filereadpost *.jpeg set ft=config
au bufreadpost,filereadpost *.jpeg set nomodified
augr END
augr *.gif
au!
au bufreadpost,filereadpost *.gif %!/usr/bin/exiftool %
au bufreadpost,filereadpost *.gif set readonly
au bufreadpost,filereadpost *.gif set ft=config
au bufreadpost,filereadpost *.gif set nomodified
augr END
augr *.png
au!
au bufreadpost,filereadpost *.png %!/usr/bin/exiftool %
au bufreadpost,filereadpost *.png set readonly
au bufreadpost,filereadpost *.png set ft=config
au bufreadpost,filereadpost *.png set nomodified
augr END

" viml function
function! ExtractZipFileAndDecompile(zipfile)
    " Zipfile looks like zipfile://path/to/file.zip::path/to/file.class
    " Extract the zipfile and classfile
    let zipfileabs = substitute(a:zipfile, 'zipfile://', '', '')
    let zipfile = substitute(zipfileabs, '::.*', '', '')
    let classfile = substitute(zipfileabs, '.*::', '', '')

    echo 'ExtractZipFileAndDecompile: ' . zipfile . ' ' . classfile

    " Extract the class file
    let tmpfile = tempname() . '.class'
    let cmd = 'unzip -p ' . zipfile . ' ' . classfile . ' > ' . tmpfile
    call system(cmd)

    " Decompile the class file
    let cmd = '/usr/local/bin/procyon ' . tmpfile
    let decompiled = system(cmd)

    " Remove the temporary file
    call delete(tmpfile)

    " Create a new window and set the buffer to the decompiled class file
    let buf = bufnr('%')
    let win = bufwinnr(buf)
    let newwin = win + 1
    execute 'new'
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    call setline(1, split(decompiled, '\n'))
    setlocal nomodified
    setlocal filetype=java
    " minimize the window
    wincmd _

    " Go back to the original window (so zip.vim can finish opening the file)
    " Wish we could kill the window but that doesn't work
    execute win . 'wincmd w'
endfunction

" Have to do this on BufReadCmd because BufReadPost doesn't work for zip files
" Files are opened with e zipfile://path/to/file.zip::path/to/file.class
" This is super hacky but it works (sorta)
au bufreadcmd  zipfile://*.class call ExtractZipFileAndDecompile(expand('<afile>'))




let g:gutentags_cache_dir = '~/.config/nvim/ctags/mytags/'
let g:gutentags_project_root = ['Makefile', '.git']

" Causes hangs for some reason
let g:gutentags_generate_on_write = 0

" Copilot
" enable copilot for yaml files
let g:copilot_filetypes = {
    \   'yaml': v:true,
    \   'TelescopePrompt': v:false
    \ }
" Map copilot panel to <M-cr> and <C-l>
"
nnoremap <C-p> <cmd>Copilot panel<CR>
inoremap <C-p> <cmd>Copilot panel<CR>
"
nnoremap <C-e> <cmd>let b:copilot_enabled = 1<CR>
inoremap <C-e> <cmd>let b:copilot_enabled = 1<CR>
"" Disable copilot by default
let b:copilot_enabled = 0
autocmd BufNewFile,BufRead * let b:copilot_enabled = 0



" Telescope
" Using Lua functions
"nnoremap <C-o> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <C-t> <cmd>lua require('telescope.builtin').tags()<cr>

" neoformat enabled for languages
let g:neoformat_enabled_javascript = ['prettier-eslint']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_html = ['prettier']
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_yaml = ['prettier']

let g:neoformat_enabled_json = ['jq']
let g:neoformat_enabled_csv = ['prettydiff']
let g:neoformat_enabled_sql = ['sqlformat']
let g:neoformat_enabled_xml = ['prettydiff']

let g:neoformat_enabled_rust = ['rustfmt']
let g:neoformat_enabled_go = ['gofmt']
let g:neoformat_enabled_php = ['phpcbf']
let g:neoformat_enabled_python = ['black']
let g:neoformat_enabled_java = ['uncrustify']
let g:neoformat_enabled_lua = ['stylua']
let g:neoformat_enabled_perl = ['perltidy']

let g:neoformat_enabled_c = ['clang-format']
let g:neoformat_enabled_cpp = ['clang-format']
let g:neoformat_enabled_objc = ['clang-format']

let g:neoformat_enabled_sh = ['shfmt']
let g:neoformat_enabled_zsh = ['shfmt']
let g:neoformat_enabled_bash = ['shfmt']


nnoremap <leader>f <cmd>Neoformat<cr>
vnoremap <leader>f <cmd>'<,'>:Neoformat<cr><esc>

" lazygit
nnoremap <leader>gg <cmd>FloatermNew --name=lazygit --width=0.9 --height=0.9 --autoclose=2 lazygit<cr>

" Bring back FZF as the fuzzy file finder because I like it better
map <C-o> <cmd>Files<CR>

" ,c to bring up ColorPicker
nnoremap <silent> <leader>c <cmd>PickColor<CR>


nnoremap <leader>o <cmd>%! ~/tools/openai_vim.py<CR>
vnoremap <leader>o <cmd>'<,'>! ~/tools/openai_vim.py<CR>

nnoremap <leader>i <cmd>%! ~/tools/dalle_vim.py<CR>
vnoremap <leader>i <cmd>'<,'>! ~/tools/dalle_vim.py<CR>


lua require('config')
