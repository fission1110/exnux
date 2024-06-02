
-- <leader>n to toggle NERDTree
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Open NERDTree on startup
vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  command = 'NERDTree | wincmd p',
})
-- NERDTree settings
vim.g.NERDTreeWinSize = 25
vim.g.NERDTreeWinPos = "left"

-- Close NERDTree when it's the only window left
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  command = 'if tabpagenr("$") == 1 && winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | quit | endif',
})
