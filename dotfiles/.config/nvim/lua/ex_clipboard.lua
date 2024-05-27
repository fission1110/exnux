
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

