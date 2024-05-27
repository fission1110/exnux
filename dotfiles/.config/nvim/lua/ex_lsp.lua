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

-- Set filetype to yaml.ansible for ansible files
vim.filetype.add({
  pattern = {
    ['*/playbooks/*.yml'] = 'yaml.ansible',
    ['*/playbooks/*.yaml'] = 'yaml.ansible',
    ['*/roles/*/tasks/*.yml'] = 'yaml.ansible'
  }
})

vim.cmd('autocmd BufNewFile,BufRead */playbooks/*.yml setfiletype yaml.ansible')
vim.cmd('autocmd BufNewFile,BufRead */playbooks/*.yaml setfiletype yaml.ansible')
lspconfig.ansiblels.setup{
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  filetypes = { "yaml.ansible" },
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
