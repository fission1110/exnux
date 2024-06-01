-- ---------
-- lualine theme
-- ---------
local function getActiveLsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local prefix = " "
  local client_names = ""
  if next(clients) == nil then
    return ""
  end

  for _, client in pairs(clients) do
    if client.name ~= "GitHub Copilot" then
      client_names = client_names .. client.name .. " "
    end
  end
  if client_names == "" then
    return ""
  end
  return prefix .. client_names
end

require('lualine').setup({
  options = {
    globalstatus = true,
    theme = 'terafox'
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics', getActiveLsp },
    lualine_c = { { 'filename', file_status = true, path = 1 } },
    lualine_x = { 'encoding', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  }
})
