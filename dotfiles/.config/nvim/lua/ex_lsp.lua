-- ---------
-- lspconfig
-- ---------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gK', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gx', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ff', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local servers = { 'pyright', 'clangd', 'html', 'cssls', 'intelephense', 'gopls', 'rust_analyzer' }
for _, lsp in pairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end

vim.lsp.config('lua_ls', {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
vim.lsp.enable('lua_ls')

-- Set filetype to yaml.ansible for ansible files
vim.filetype.add({
  pattern = {
    ['*/playbooks/*.yml'] = 'yaml.ansible',
    ['*/playbooks/*.yaml'] = 'yaml.ansible',
    ['*/roles/*/tasks/*.yml'] = 'yaml.ansible'
  }
})

vim.cmd('autocmd BufNewFile,BufRead */playbooks/**.yml setfiletype yaml.ansible | echom "hit set ft yaml.ansible"')
vim.cmd('autocmd BufNewFile,BufRead */playbooks/**.yaml setfiletype yaml.ansible | echom "hit set ft yaml.ansible"')

vim.lsp.config('tsserver', {
  on_attach = on_attach,
  capabilities = capabilities,
})
vim.lsp.enable('tsserver')

vim.lsp.config('eslint', {
  on_attach = on_attach,
  settings = {
  },
  capabilities = capabilities,
})
vim.lsp.enable('eslint')
vim.lsp.config('diagnosticls', {
  cmd = { "diagnostic-languageserver", "--stdio" },
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "python", "javascript" },
  init_options = {
    formatters = {
      autopep8 = {
        command = "autopep8",
        args = { "-" },
      },
      prettier = {
        command = "prettier",
        args = { "--stdin-filepath", "%filepath" },
      },
    },
    formatFiletypes = { python = "autopep8", javascript = "prettier" },
  }

})
vim.lsp.enable('diagnosticls')
