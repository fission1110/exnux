vim.cmd("call pathogen#infect()")
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
require('ex_lualine')

-- Keybind reload init.vim
local function reloadVim()
  vim.cmd('so ~/.config/nvim/init.vim')
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/lua/*.lua', 0, 1)) do
    vim.cmd('luafile ' .. file)
  end
end
vim.keymap.set('n', '<leader>r', reloadVim, { noremap = true, silent = true, expr = true })
