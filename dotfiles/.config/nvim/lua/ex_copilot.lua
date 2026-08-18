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

function CopilotBufToggle() if vim.b.copilot_enabled == 1 then
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

--vim.g.copilot_filetypes = {
--  yaml = true,
--  TelescopePrompt = false,
--}
-- Disable copilot by default
--vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
--  pattern = '*',
--  callback = CopilotBufDisable,
--})

require("codecompanion").setup({
  adapters = {
    acp = {
      codex = function()
        return require("codecompanion.adapters").extend("codex", {
          defaults = {
            auth_method = "api-key", -- "api-key"|"chat-gpt"
          },
          env = {
            OPENAI_API_KEY = vim.env.OPENAI_API_KEY,
          },
        })
      end,
    },
  },
  interactions = {
    chat = {
      adapter = {
        name = "openai_responses",
        model = "gpt-5.6-terra",
      },
    },

    inline = {
      adapter = {
        name = "copilot",
      },
    },

    -- Fast non-agentic editing through the OpenAI Responses API.
    cmd = {
      adapter = {
        name = "openai_responses",
        model = "gpt-5.6-luna",
      },
    },

    -- Cheap model for automatically generated chat titles and other background work.
    background = {
      adapter = {
        name = "openai_responses",
        model = "gpt-5.6-luna",
      },
    },
  },
})
vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, expr = false })

-- Open a separate on-demand ACP Codex session. The default chat remains gpt-5.6-terra.
vim.api.nvim_create_user_command('CodeCompanionCodexChat', function()
  vim.cmd('CodeCompanionChat adapter=codex')
end, { desc = 'Open a CodeCompanion chat using Codex' })
vim.keymap.set('n', '<leader>cx', '<cmd>CodeCompanionCodexChat<cr>', {
  noremap = true,
  silent = true,
  desc = 'CodeCompanion: open Codex chat',
})

vim.keymap.set('n', '<leader>c', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, expr = false })
vim.keymap.set('n', '<leader>ci', '<cmd>CodeCompanion<cr>', { noremap = true, silent = true, expr = false })
vim.keymap.set('v', '<leader>c', ':CodeCompanion<cr>', { noremap = true, silent = true, expr = false })

