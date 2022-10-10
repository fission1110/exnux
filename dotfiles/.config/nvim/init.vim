call pathogen#infect()
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $TERM="screen-256color"
set mouse=          " disable mouse support
set showcmd		    " Show (partial) command in status line.
set synmaxcol=600   " Don't syntax highlight long lines.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set nowrap	"Don't wrap long lines
set hidden	"Hide edited buffers rather than quit them
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

let mapleader="," "Set the leader key

set relativenumber
set nu "Show line numbers
set fileencodings=utf-8 "Force utf8

"stop stupid .swp files from showing up ever. If you need them, they're in
"~/.cache/swp
set backupdir=/home/nonroot/.cache/nvim/swp,.
set directory=/home/nonroot/.cache/nvim/swp,.

" persistent undo
set undodir=/home/nonroot/.cache/nvim/undo
set undofile

" Remap redraw to <leader>r
nmap <leader>r :redraw!<CR>jk

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

" Easily move up and down pages
noremap <M-j> <C-d>
noremap <M-k> <C-u>

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
nmap <leader>hh :%!xxd<cr>
nmap <leader>hu :%!xxd -r<cr>

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


"#############Ctrlp#############
let g:ctrlp_working_path_mode = ''

" My hack to the forked version of vim snipmate to ignore the
" fact that the pumvisible() and use my snippets anyways.
let g:snipmateIgnorePum = 1
let g:snipMate = get(g:, 'snipMate', {}) "
let g:snipMate.snippet_version = 0
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['php'] = 'php'

inoremap <C-l> <C-x><C-o>

let g:vdebug_options = {
\    "port" : 9000,
\    "server" : '',
\    "timeout" : 60,
\    "on_close" : 'detach',
\    "break_on_open" : 0,
\    "ide_key" : '',
\    "path_maps" : {'/code' : '/home/nonroot/code'},
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

"change the statusline highlighted background color to black
"
command -nargs=? Guifont call rpcnotify(0, 'Gui', 'SetFont', "<args>")
" Set font on start
let g:Guifont="DejaVu Sans Mono for Powerline:h13"

" disable the online shortcut because it conflicts with <C-h> (move to left window)
let g:php_manual_online_search_shortcut=''

" Some autocomplete command? what is this?
:inoremap # X#

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

nmap <leader>s :Scratch<cr>
let g:scratch_persistence_file="/tmp/nvim_scratch_persistance"

" ansible syntax highlighting
au BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible

augr class
au!
au bufreadpost,filereadpost *.class %!/usr/local/bin/procyon %
au bufreadpost,filereadpost *.class set readonly
au bufreadpost,filereadpost *.class set ft=java
au bufreadpost,filereadpost *.class normal gg=G
au bufreadpost,filereadpost *.class set nomodified
augr END

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
" Map copilot panel to <M-cr>
nnoremap <M-CR> :Copilot panel<CR>
inoremap <M-CR> <ESC>:Copilot panel<CR>

" Telescope
" Using Lua functions
"nnoremap <C-o> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-f> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <C-t> <cmd>lua require('telescope.builtin').tags()<cr>

" lazygit
nnoremap <leader>gg :FloatermNew --name=lazygit --width=0.9 --height=0.9 --autoclose=2 lazygit<cr>

" Bring back FZF as the fuzzy file finder because I like it better
map <C-o> :Files<CR>

lua require('config')
