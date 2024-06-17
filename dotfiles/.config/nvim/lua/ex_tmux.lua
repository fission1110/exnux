local function setTmuxName(name)
  vim.fn.system("tmux rename-window '" .. name .. "'")
end

local function buildTmuxFilename()
  -- Get the current working directory
  local cwd = vim.fn.getcwd()
  local lastPath = vim.fn.fnamemodify(cwd, ':t')
  local prefix = 'nvim '

  return prefix .. lastPath
end

local function reloadTmuxName()
  local name = buildTmuxFilename()
  setTmuxName(name)
end

local function undoTmuxName()
  local shellName = vim.env.SHELL
  local windowName = vim.fn.fnamemodify(shellName, ':t')
  setTmuxName(windowName)
end

if not vim.g.ex_tmux_loaded then
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    pattern = '*',
    command = 'lua require("ex_tmux").ReloadTmuxName()',
  })

  -- On vim close, set the tmux name to the name of the shell
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    callback = function()
      require("ex_tmux").UndoTmuxName()
    end,
  })
end


vim.g.ex_tmux_loaded = true
-- exports
return {
  ReloadTmuxName = reloadTmuxName,
  SetTmuxName = setTmuxName,
  UndoTmuxName = undoTmuxName,
}
