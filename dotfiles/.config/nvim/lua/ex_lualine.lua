-- ---------
-- lualine theme
-- ---------
local function getActiveLsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local prefix = "󰚥 "
  local client_names = ""
  if next(clients) == nil then
    return ""
  end

  for _, client in pairs(clients) do
    if client.name ~= "GitHub Copilot" then
      client_names = client_names .. prefix .. client.name .. " "
    end
  end
  if client_names == "" then
    return ""
  end
  return client_names
end

local function getExpandTab()
  if vim.bo.expandtab then
    return "󱁐"
  else
    return ""
  end
end

local function getTabStatusline()
  return getExpandTab() .. "  " .. vim.bo.shiftwidth
end

require("lualine").setup({
  options = {
    globalstatus = true,
    theme = "terafox",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      "diff",
      {
        "diagnostics",
        symbols = {
          error = " ", -- nerdfont xe654
          warn = " ", -- xf529
          info = " ", -- nerdfont xf05a
          hint = " ", -- nerdfont xf059
        },
      },
      CopilotStatusIcon,
      getActiveLsp,
    },
    lualine_c = { { "filename", file_status = true, path = 1 } },
    lualine_x = { getTabStatusline, "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
