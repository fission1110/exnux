function CopilotBufEnable()
  vim.b.copilot_enabled = 1;
end

function CopilotBufDisable()
  -- Can't disable copilot if it's globally enabled
  if vim.g.copilot_enabled == 1 then
    return
  end
  vim.b.copilot_enabled = 0;
end

function CopilotBufToggle()
  if vim.b.copilot_enabled == 1 then
    CopilotBufDisable()
  else
    CopilotBufEnable()
  end
end

function CopilotEnable()
  vim.g.copilot_enabled = 1;
  CopilotBufEnable()
end

function CopilotDisable()
  vim.g.copilot_enabled = 0;
end

function CopilotToggle()
  if vim.g.copilot_enabled == 1 then
    CopilotDisable()
  else
    CopilotEnable()
  end
end

function CopilotStatusIcon()
  local icon = ""
  -- b:copilot_enabled
  if vim.g.copilot_enabled == 1 then
    return icon .. ""
  end
  if vim.b.copilot_enabled == 1 then
    return icon
  end
  return ""
end

-- keymaps
vim.keymap.set('n', '<leader>cg', CopilotToggle, { noremap = true, silent = true, expr = true })
vim.keymap.set('n', '<leader>c', CopilotBufToggle, { noremap = true, silent = true, expr = true })
vim.keymap.set('n', '<leader>cp', '<cmd>Copilot Panel<cr>', { noremap = true, silent = true, expr = false })

vim.g.copilot_filetypes = {
  yaml = true,
  TelescopePrompt = false,
}
-- Disable copilot by default
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*',
  callback = CopilotBufDisable,
})
