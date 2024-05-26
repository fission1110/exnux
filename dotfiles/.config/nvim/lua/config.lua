vim.cmd("call pathogen#infect()")
-- ---------
-- lualine theme
-- ---------
require('lualine').setup({
    options = {
        globalstatus = true,
        theme = 'terafox'
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
})

require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' }
  }
})

require'cmp'.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})


-- ---------
-- treesitter
-- ---------
require'nvim-treesitter.configs'.setup {

  -- A list of parser names, or "all"
  ensure_installed = { "bash", "c", "c_sharp", "clojure", "cmake", "comment", "commonlisp", "cpp", "css", "dart", "dockerfile", "elm", "fortran", "go", "gomod", "graphql", "hack", "haskell", "html", "http", "java", "javascript", "jsdoc", "json", "json5", "jsonc", "julia", "kotlin", "latex", "llvm", "lua", "make", "markdown", "ninja", "pascal", "perl", "php", "python", "r", "regex", "ruby", "rust", "scala", "scheme", "scss", "swift", "typescript", "verilog", "vim", "vue", "yaml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
-- ---------
-- treesitter context
-- ---------
require'treesitter-context'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function', 'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {
            'chapter',
            'section',
            'subsection',
            'subsubsection',
        },
        rust = {
            'impl_item',
            'struct',
            'enum',
        },
        scala = {
            'object_definition',
        },
        vhdl = {
            'process_statement',
            'architecture_body',
            'entity_declaration',
        },
        markdown = {
            'section',
        },
        elixir = {
            'anonymous_function',
            'arguments',
            'block',
            'do_block',
            'list',
            'map',
            'tuple',
            'quoted_content',
        },
        json = {
            'pair',
        },
        yaml = {
            'block_mapping_pair',
        },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
}
-- ---------
-- lspconfig
-- ---------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gK', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gx', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { 'pyright', 'tsserver', 'clangd', 'html', 'cssls', 'phpactor', 'gopls', 'rust_analyzer'}
local lspconfig = require('lspconfig')
for _, lsp in pairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
      },
      capabilities = capabilities,
    }
end

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

lspconfig.ansiblels.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  filetypes = { "yaml", "ansible" },
  root_dir = lspconfig.util.root_pattern("playbooks", "roles"),
  capabilities = capabilities,
}

lspconfig.eslint.setup({
      on_attach = on_attach,
      flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
      },
      settings = {
      },
      capabilities = capabilities,
})
-- ---------
-- nvim-cmp
-- ---------
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      select = false,
      behavior = cmp.ConfirmBehavior.Replace,
    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

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




require("color-picker").setup({ -- for changing icons & mappings
	-- ["icons"] = { "ﱢ", "" },
	-- ["icons"] = { "ﮊ", "" },
	-- ["icons"] = { "", "ﰕ" },
	-- ["icons"] = { "", "" },
	-- ["icons"] = { "", "" },
	["icons"] = { "ﱢ", ">" },
	["border"] = "rounded", -- none | single | double | rounded | solid | shadow
	["keymap"] = { -- mapping example:
		["U"] = "<Plug>ColorPickerSlider5Decrease",
		["O"] = "<Plug>ColorPickerSlider5Increase",
	},
	["background_highlight_group"] = "Normal", -- default
	["border_highlight_group"] = "FloatBorder", -- default
  ["text_highlight_group"] = "Normal", --default
})

require('leap').create_default_mappings()

-- Set filetype to yaml.ansible for ansible files
vim.filetype.add({
  pattern = {
    ['*/playbooks/*.yml'] = 'yaml.ansible',
    ['*/playbooks/*.yaml'] = 'yaml.ansible',
    ['*/roles/*/tasks/*.yml'] = 'yaml.ansible'
  }
})

-- If $SSH_TTY is set, use lemonade as the clipboard provider. Check on every bufenter
function set_clipboard_provider ()
  if os.getenv("SSH_TTY") then
    vim.g.clipboard = {
      name = "lemonade",
      copy = {
        ["+"] = "lemonade copy",
        ["*"] = "lemonade copy",
      },
      paste = {
        ["+"] = "lemonade paste",
        ["*"] = "lemonade paste",
      },
      cache_enabled = 0
    }
  else
    -- unset g:clipboard
    vim.g.clipboard = nil
  end
end
-- Call set_clipboard_provider on bufenter
vim.cmd("autocmd BufEnter * lua set_clipboard_provider()")

--- Setup dap
local dap = require('dap')
local dapui = require('dapui')
local dappython = require('dap-python')
local dapgo = require('dap-go')
local nvim_dap_virtual_text = require("nvim-dap-virtual-text")

nvim_dap_virtual_text.setup()
dapui.setup({
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
})
dappython.setup()
dapgo.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  -- Hide NerdTree
  vim.cmd("NERDTreeClose")
  -- Open DAP UI
  dapui.open()
  -- Set keymaps
  vim.api.nvim_set_keymap('n', 'J', '<cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'L', '<cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', 'H', '<cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
end
dap.listeners.before.event_terminated.dapui_config = function()

  -- Unmap keymaps
  vim.api.nvim_del_keymap('n', 'J')
  vim.api.nvim_del_keymap('n', 'L')
  vim.api.nvim_del_keymap('n', 'H')
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

dap.listeners.after.event_terminated.dapui_config = function()
  -- Show NERDTree and resize it
  vim.cmd("NERDTree")
end

-- Search for nvim-dap.lua in the current directory and all parent directories
require('nvim-dap-projects').search_project_config()

telescope.load_extension('dap')


vim.api.nvim_set_keymap('n', '<leader>db', '<cmd>lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })


dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { '/usr/local/src/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9000
  }
}
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode-9', -- adjust as needed, must be absolute path
  name = 'lldb'
}
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  }
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = {
  {
    -- ... the previous config goes here ...,
    initCommands = function()
      -- Find out where to look for the pretty printer Python module
      local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

      local commands = {}
      local file = io.open(commands_file, 'r')
      if file then
        for line in file:lines() do
          table.insert(commands, line)
        end
        file:close()
      end
      table.insert(commands, 1, script_import)

      return commands
    end,
  }
}

--- Set leap hl colors
--- LeapMatch, LeapLabelPrimary, LeapLabelSecondary
vim.cmd("highlight link LeapMatch Todo")
vim.cmd("highlight link LeapLabelPrimary Error")
vim.cmd("highlight link LeapLabelSecondary CurSearch")

