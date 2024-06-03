vim.cmd("call pathogen#infect()")


vim.o.mouse = ''
vim.o.showcmd = true
vim.o.synmaxcol = 600
vim.o.showmatch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.hidden = true
vim.o.termguicolors = true
vim.o.listchars = 'tab:»·,trail:·,nbsp:␣,extends:»,precedes:«,eol:↲'
vim.o.list = true
-- colorscheme
vim.cmd.colorscheme('terafox')
vim.cmd('syntax on')
-- clipboard
vim.o.clipboard = 'unnamedplus'
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.scrolloff = 5
-- Map leader to space
vim.g.mapleader = ' '
vim.g.termninal_scrollback_buffer_size = 100000
vim.o.relativenumber = true
vim.o.number = true
vim.o.fileencodings = 'utf-8'
-- stop stupid .swp files from showing up ever. If you need them, they're in
-- ~/.cache/swp
vim.o.backupdir = '/home/' .. vim.fn.expand('$USER') .. '/.cache/nvim/swp//,.'
vim.o.directory = '/home/' .. vim.fn.expand('$USER') .. '/.cache/nvim/swp//,.'

vim.o.undofile = true
vim.o.undodir = '/home/' .. vim.fn.expand('$USER') .. '/.cache/nvim/undo//,.'

vim.o.shada = "!,'1000,<50,s10,h"
vim.o.shadafile = '/home/' .. vim.fn.expand('$USER') .. '/.cache/nvim/shada'


-- python uses 4 spaces (PEP8) expandtab
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'python',
  command = 'setlocal ts=4 sw=4 smartindent expandtab',
})
-- php is tabs
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'php',
  command = 'setlocal ts=4 sw=4 smartindent autoindent noexpandtab',
})
-- set filetype for messages
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  pattern = '*messages*',
  command = 'set filetype=messages',
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'c',
  command = 'setlocal tags+=~/.config/nvim/ctags/systags',
})

-- turn on javascript snippets in typescript files
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.ts',
  command = 'set ft=typescript.javascript',
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'typescript',
  command = 'setlocal ts=2 sw=2 expandtab',
})
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'html',
  command = 'setlocal ts=2 sw=2 expandtab',
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.php',
  command = 'set ft=php',
})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.ctp',
  command = 'set ft=php.html',
})

-- Clear background for transparent background
vim.cmd('hi Normal ctermbg=NONE guibg=NONE')
vim.cmd('hi NormalNC ctermbg=NONE guibg=NONE')
vim.cmd('hi StatusLine ctermbg=NONE guibg=NONE')
vim.cmd('hi StatusLineNC ctermbg=NONE guibg=NONE')

-- Set the ExtraWhiteSpace highlight group to display extra whitespace
vim.cmd('match ExtraWhitespace /\\s\\+$/')
vim.cmd('highlight ExtraWhitespace ctermbg=red guibg=red')

-- Set the VertSplit highlight group to change the color of the split line
vim.cmd('highlight VertSplit guifg=#587b7b')

-- Insert mode when entering the terminal
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = 'term://*',
  command = 'if &buftype == "terminal" | startinsert | endif',
})
-- no line numbers in terminal
vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  pattern = '*',
  command = 'setlocal nonumber norelativenumber',
})

-- set the split direction. I don't remember why I set this like this
vim.o.splitright = true
vim.o.splitbelow = true

--"" Causes hangs for some reason
vim.g.gutentags_generate_on_write = 0
vim.g.gutentags_cache_dir = '/home/' .. vim.fn.expand('$USER') .. '/.config/nvim/ctags/mytags/'
vim.g.gutentags_project_root = { 'Makefile', '.git' }

-- Try to auto detect and use the indentation of a file when opened.
--autocmd BufRead * DetectIndent
vim.api.nvim_create_autocmd({ 'BufRead' }, {
  pattern = '*',
  command = 'DetectIndent',
})
-- Set a fallback here in case detection fails and there is no file type
-- plugin available. You can also omit this, then Vim defaults to tabs.
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
-- You stay in control of your tabstop setting.
vim.o.tabstop = 4
-- Otherwise use file type specific indentation. E.g. tabs for Makefiles
-- and 4 spaces for Python. This is optional.
vim.cmd('filetype plugin indent on')

require('ex_tmux')
require('ex_lsp')
require('ex_copilot')
require('ex_ls')
require('ex_cmp')
require('ex_ts')
require('ex_dap')
require('ex_telescope')
require('ex_colorpicker')
require('ex_leap')
require('ex_clipboard')
require('ex_reverse_eng')
require('ex_nerdtree')
require('ex_keymaps')
require('ex_lualine')
