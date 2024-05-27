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
  -- if J is mapped
  if vim.api.nvim_buf_get_keymap(0, 'n', 'J') then
    vim.api.nvim_del_keymap('n', 'J')
  end
  -- if L is mapped
  if vim.api.nvim_buf_get_keymap(0, 'n', 'L') then
    vim.api.nvim_del_keymap('n', 'L')
  end
  -- if H is mapped
  if vim.api.nvim_buf_get_keymap(0, 'n', 'H') then
    vim.api.nvim_del_keymap('n', 'H')
  end
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
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
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

dap.adapters.ansible = {
  type = 'executable',
  command = '/usr/local/src/ansible/bin/python',
  args = { '-m', 'ansibug', 'dap' },
}

dap.configurations["yaml.ansible"] = {
  {
    type = 'ansible',
    request = 'launch',
    name = 'Debug Playbook',
    playbook = "${file}",
  },
}
