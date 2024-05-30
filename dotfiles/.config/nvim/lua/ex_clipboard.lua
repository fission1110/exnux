
-- If $SSH_TTY is set, use lemonade as the clipboard provider. Check on every bufenter
function set_clipboard_provider ()
  -- Stat the file ~/.ssh_connected to see if it exists
  local f = io.open(os.getenv("HOME") .. "/.ssh_connected", "r")
  local ssh_connected = f ~= nil
  if ssh_connected then
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

