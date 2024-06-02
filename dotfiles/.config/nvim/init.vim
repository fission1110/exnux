let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Telescope
" Using Lua functions
"nnoremap <C-o> <cmd>lua require('telescope.builtin').find_files()<cr>

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
"let g:neoformat_enabled_php = ['phpcbf']
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

" Execute inline
au FileType python vnoremap <leader>e <cmd>'<,'>!python<CR>
au FileType javascript vnoremap <leader>e <cmd>'<,'>!node<CR>
au FileType bash vnoremap <leader>e <cmd>'<,'>!bash<CR>

lua require('config')

