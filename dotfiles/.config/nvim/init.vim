call pathogen#infect()
"let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let $TERM="screen-256color"
set title titlestring=%{getcwd()}\ (%{fnamemodify(expand(\"%\"),\ \":~:.\")})\ -\ NVIM
set mouse=
set showcmd		" Show (partial) command in status line.
set synmaxcol=600
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set nowrap	"Don't wrap long lines
set hidden	"Hide edited buffers rather than quit them
let g:terminal_scrollback_buffer_size = 100000

set clipboard+=unnamedplus

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

let mapleader="," "Set the leader key 
syntax on
filetype plugin on

"set relativenumber
set nu "Show line numbers
set fileencodings=utf-8 "Force utf8

"stop stupid .swp files from showing up ever. If you need them, they're in
"/tmp
set backupdir=/tmp,.
set directory=/tmp,.
nmap <leader>r :redraw!<CR>jk

" Semi colon aliased to :
nnoremap ; :

"Go back and go forward
nnoremap { <C-O>
nnoremap } <C-i>

"w!! will now sudo write the file
cmap w!! SudaWrite

" This doesn't seem to work in nvim
"vmap <leader>y "+y
"vmap <leader>y "+p

""""" EASY GREP STUFF """"""""
nmap <C-f> :Grep 
"let g:EasyGrepDefaultUserPattern='*.php *.ctp *.js *.po'
let g:EasyGrepFileAssociations=$HOME."/.config/nvim/bundle/vim-easygrep/plugin/EasyGrepFileAssociations"
let g:EasyGrepMode=0
let g:EasyGrepCommand=1
let g:EasyGrepRecursive=1
let g:EasyGrepSearchCurrentBufferDir=0
let g:EasyGrepIgnoreCase=1
let g:EasyGrepHidden=0
let g:EasyGrepFilesToExclude='main.js *webroot/js/languages'
let g:EasyGrepAllOptionsInExplorer=1
let g:EasyGrepWindow=0
let g:EasyGrepReplaceWindowMode=2
let g:EasyGrepOpenWindowOnMatch=1
let g:EasyGrepEveryMatch=0
let g:EasyGrepJumpToMatch=0
let g:EasyGrepInvertWholeWord=0
let g:EasyGrepFileAssociationsInExplorer=0
let g:EasyGrepExtraWarnings=1
let g:EasyGrepOptionPrefix='<leader>vy'
let g:EasyGrepReplaceAllPerFile=0


" Easily jump around windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" ,ee will run the file
au FileType sh nmap <leader>ee :exec '!bash' shellescape(@%, 1)<cr>
xnoremap <leader>er :!python<cr>

au FileType python setlocal ts=4 sw=4 smartindent expandtab
au FileType php setlocal ts=4 sw=4 smartindent noexpandtab

au FileType c nmap <leader>ee :exec '!gcc -o test ' shellescape(@%, 1)<cr> :exec '!./test'<cr>
au FileType c nmap <leader>ei :exec '!gcc -g -o test ' shellescape(@%, 1)<cr> :exec '!gdb ./test'<cr>

au FileType php nmap <leader>ee :VdebugStart<cr>

au FileType mysql nmap <leader>ee :exec '!mysql -u root -ppassword < ' shellescape(@%, 1)<cr>
au FileType postgres nmap <leader>ee :exec '!postgres -u root -ppassword < ' shellescape(@%, 1)<cr>

au FileType sql set ft=mysql

"Set ft=messages when file is called messages
autocmd BufNewFile,BufReadPost *messages* :set filetype=messages

" Use systags with c
autocmd  FileType  c setlocal tags+=~/.config/nvim/ctags/systags

" Search for ctags
"autocmd  BufReadPost * exec Findctags(1)

"#############Nerdtree stuff#############
autocmd VimEnter * NERDTree | wincmd p
let g:NERDTreeWinSize = 35
let g:NERDTreeWinPos = "left"
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 2 && bufexists('-MINIMAP-') && exists('b:NERDTree') && (b:NERDTree.isTabTree() || bufname() == '-MINIMAP-') | quitall | endif


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

" If 1, losen the restrictions on ctags to include c, c++, etc files..
nmap <f9> :call Findctags(0)<CR>
nmap <f10> :call Updatectags(1)<CR>
nmap <f12> :call Updatectags(0)<CR>

function! Updatectags(more)
    echo "Updating more Ctags!"
	" If more, losen the restrictions on ctags to include c, c++, etc files..
	if a:more
		execute "!~/.config/nvim/ctags/ctags_update_more.sh"
	else
		execute "!~/.config/nvim/ctags/ctags_update_".&ft.".sh"
	endif
   	let cwd = getcwd()."/main"
	let ctags_file = $HOME . "/.config/nvim/mytags"
    let  &tags = ctags_file.cwd.".".&ft
endfunction

function! Findctags(silent)
    if a:silent == 0
        echo "Finding Ctags!"
    endif
   	let cwd = getcwd().""
	let ctags_file = $HOME . "/.config/nvim/ctags/mytags"
    let ctags_path = ctags_file.cwd."/"
    let loopcount = 0
    while !filereadable(ctags_path."main.".&ft) && loopcount < 10
        let ctags_path = substitute(ctags_path, '[^\/]\{-}\/$', '', '')
		if a:silent == 0
			echo "looking in: ".ctags_path."main.".&ft
		endif
        let loopcount = loopcount + 1
    endwhile
    if a:silent == 0
        echo ctags_path."main.".&ft
    endif
    let  &tags = ctags_path."main.".&ft
endfunction

"#############Ctrlp#############
let g:ctrlp_working_path_mode = ''

command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? 'GFiles' : 'Files'
map <C-p> :Ctrlp<CR>

" Use fzf instead of ctrlt
nnoremap <c-t> :Tags<cr>

"let g:SuperTabNoCompleteAfter = ['^', ',', '\s']
let g:SuperTabDefaultCompletionType = "<c-n>"

" vim-jedi go to definition
au FileType python nmap <c-]> <leader>d
" tern_for_vim go to defenition
" au FileType javascript nmap <c-]> :TernDef<cr>

" My hack to the forked version of vim snipmate to ignore the
" fact that the pumvisible() and use my snippets anyways.
let g:snipmateIgnorePum = 1
let g:snipMate = get(g:, 'snipMate', {}) "
let g:snipMate.snippet_version = 0
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['php'] = 'php'

let g:jedi#auto_close_doc = 0
let g:jedi#completions_enabled = 0

"au FileType php setlocal omnifunc=phpcomplete_extended#CompletePHP
"let g:deoplete#sources#padawan#auto_update = 1
"
"Deoplete ternjs requires multiple threads https://github.com/carlitux/deoplete-ternjs/issues/88
call deoplete#custom#option('num_processes', 4)
let g:deoplete#sources#ternjs#types = 1

let g:tern_set_omni_function = 0

let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1


inoremap <C-l> <C-x><C-o>

let g:phpcomplete_complete_for_unknown_classes = 0
"let g:deoplete#sources._ = ['buffer', 'tag']
"set completeopt=longest,menuone,preview
"inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


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
"execute python, then drop to the interpreter
au FileType python nmap <leader>ee :exec '!python3' shellescape(@%, 1)<cr>
"execute python
au FileType python nmap <leader>ei :exec '!python' shellescape(@%, 1)<cr>


let g:jellybeans_use_lowcolor_black = 0

"Search: green bg grey fg underline
"Identifier(varibles): light deep blue fg
"DbgBreakptLine: green bg grey  fg
"Statement: bluegreen foreground
let g:jellybeans_overrides = {
\    'Search': { 'guifg': '1c1c1c', 'guibg': '99ad6a',
\              'ctermfg': 'Magenta', 'ctermbg': '',
\              'attr': 'underline' },
\    'Identifier': { 'guifg': '5B79BA', 'guibg': '',
\              'ctermfg': 'LightCyan', 'ctermbg': '',
\              'attr': '' },
\    'DbgBreakptLine': { 'guifg': '1c1c1c', 'guibg': '99ad6a',
\              'ctermfg': '1c1c1c', 'ctermbg': '99ad6a',
\              'attr': '' },
\    'Statement': { 'guifg': '447799', 'guibg': '',
\              'ctermfg': '447799', 'ctermbg': '',
\              'attr': '' },
\}


set background=dark
colorscheme jellybeans

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

"change the statusline highlighted background color to black
"
hi StatusLine gui=none guibg=DarkGrey cterm=none ctermbg=DarkGrey
hi Normal gui=none guibg=none cterm=none ctermbg=none
hi NonText gui=none guibg=none  cterm=none ctermbg=none
" Neovim-qt Guifont command, to change the font
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

" syntastic syntax checking
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
nmap <leader>S :SyntasticToggle<cr>
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes":[], "passive_filetypes":[]}
let g:syntastic_php_phpcs_args = "--standard="
let g:phpcomplete_index_composer_command = '/usr/local/bin/composer.phar'

let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-6.0/lib/libclang.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/include/clang'
augr class
au!
au bufreadpost,filereadpost *.class %!/usr/local/src/jad/jad -noctor -ff -i -p %
au bufreadpost,filereadpost *.class set readonly
au bufreadpost,filereadpost *.class set ft=java
au bufreadpost,filereadpost *.class normal gg=G
au bufreadpost,filereadpost *.class set nomodified
augr END
"autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%F"))

let g:gutentags_cache_dir = '~/.config/nvim/ctags/mytags/'
let g:gutentags_project_root = ['Makefile', '.git']
" Causes hangs for some reason
let g:gutentags_generate_on_write = 0

" Terminal code minimap
let g:minimap_width = 20
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1
