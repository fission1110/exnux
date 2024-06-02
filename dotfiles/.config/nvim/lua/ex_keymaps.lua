-- Keybind reload init.vim
local function reloadVim()
  vim.cmd('so ~/.config/nvim/init.vim')
  for _, file in ipairs(vim.fn.glob('~/.config/nvim/lua/*.lua', 0, 1)) do
    vim.cmd('luafile ' .. file)
  end
end
vim.keymap.set('n', '<leader>r', reloadVim, { noremap = true, silent = true, expr = true })

-- Remap ; to : in normal mode
vim.keymap.set('n', ';', ':', { noremap = true, silent = true, expr = false })

--Go back and go forward
vim.keymap.set('n', '{', '<C-O>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '}', '<C-I>', { noremap = true, silent = true, expr = false })

-- w!! will now sudo write the file
vim.keymap.set('c', 'w!!', 'SudaWrite', { noremap = true, silent = true, expr = false })

-- Easily jump around windows
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, expr = false })

-- Easily resize windows
-- Resize with alt + hjkl instead of ctrl + w + hjkl
vim.keymap.set('n', '<M-j>', ':resize -2<CR>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<M-k>', ':resize +2<CR>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<M-h>', ':vertical resize -2<CR>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<M-l>', ':vertical resize +2<CR>', { noremap = true, silent = true, expr = false })

-- Easily move up and down pages
-- Use alt + u and alt + d to move up and down pages
vim.keymap.set('n', '<M-u>', '<C-u>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<M-d>', '<C-d>', { noremap = true, silent = true, expr = false })

-- HEX MODE!!
vim.keymap.set('n', '<leader>hh', '<cmd>!xxd<CR>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<leader>hu', '<cmd>!xxd -r<CR>', { noremap = true, silent = true, expr = false })

--" ESC sends <ESC> key to terminal (good for nested vim). Press ESC ESC to
--" really escape.
vim.keymap.set('t', '<ESC><ESC>', '<C-\\><C-n>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<ESC>', '<ESC>', { noremap = true, silent = true, expr = false })

vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<C-l><C-l>', '<C-\\><C-n><C-w><C-l>', { noremap = true, silent = true, expr = false })
vim.keymap.set('t', '<C-l>', '<C-l>', { noremap = true, silent = true, expr = false })


-- <leader>ti/<leader>ts to terminal split, somewhat matching nerdtree
vim.keymap.set('n', '<leader>ti', ':execute "split sp \\| term"<cr>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<leader>ts', ':execute "vert sp \\| term"<cr>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<leader>tt', ':tabnew term://$SHELL<cr>', { noremap = true, silent = true, expr = false })

-- lazygit
vim.api.nvim_set_keymap('n', '<leader>gg', '<cmd>FloatermNew --name=lazygit --width=0.9 --height=0.9 --autoclose=2 lazygit<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>f', '<cmd>Neoformat<cr>', { noremap = true, silent = true })

-- <leader>cp to bring up ColorPicker
vim.api.nvim_set_keymap('n', '<leader>cp', '<cmd>PickColor<CR>', { noremap = true, silent = true })
