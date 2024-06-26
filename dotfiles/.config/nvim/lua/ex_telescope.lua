-- telescope ignore patterns
local telescope = require("telescope")
local ex_tmux = require("ex_tmux")
telescope.setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "exploits", "shellcodes" },
    hidden = true,
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
    history = {
      path = '~/.cache/nvim/.telescope_history',
      limit = 1000,
    },
  },
  extensions = {
    zoxide = {
      mappings = {
        default = {
          after_action = function(selection)
            -- get the window number
            local winnr = vim.api.nvim_get_current_win()
            -- Run :NERDTree.IsOpen() to check if NERDTree is open
            local nerdtreeopen = vim.api.nvim_eval('NERDTree.IsOpen()')
            -- CD to the selected directory
            vim.cmd('NERDTreeCWD')
            -- Set focus back to the window
            vim.api.nvim_set_current_win(winnr)
            if nerdtreeopen ~= 1 then
              vim.cmd('NERDTreeClose')
            end
            ex_tmux.ReloadTmuxName()
          end
        },
      },
    },
  },
}
telescope.load_extension('gh')
telescope.load_extension('dap')
telescope.load_extension('zoxide')

vim.api.nvim_set_keymap('n', '<leader>z', '<cmd>Telescope zoxide list<cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require("telescope.builtin").live_grep()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', '<cmd>lua require("telescope.builtin").tags()<cr>', { noremap = true, silent = true })

-- Use fzf rather than telescope for find files
vim.api.nvim_set_keymap("", "<C-o>", "<cmd>Files<cr>", { noremap = true, silent = true })
