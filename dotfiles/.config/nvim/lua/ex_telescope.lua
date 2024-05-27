
-- telescope ignore patterns
local telescope = require("telescope")
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
}
telescope.load_extension('gh')
telescope.load_extension('dap')
