-- Jump
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)')
vim.keymap.set('n',               'S', '<Plug>(leap-from-window)')

-- Visit (jump - operate - jump back)
vim.keymap.set({ 'n', 'o' }, 'gs', '<Plug>(leap-visit)')
vim.keymap.set({ 'n', 'o' }, 'gS', '<Plug>(leap-visit-linewise)')
vim.keymap.set({ 'x', 'o' }, 'ar', '<Plug>(leap-visit-text-object)')
vim.keymap.set({ 'x', 'o' }, 'ir', '<Plug>(leap-visit-inner-text-object)')
vim.keymap.set({ 'o' },      'rr', '<Plug>(leap-visit-line)')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VisitDone',
  group = vim.api.nvim_create_augroup('VisitorMode', {}),
  callback = function(event)
    if vim.v.operator == 'y' and event.data.register == '"' then
      vim.cmd('normal! p')
    end
  end,
})

-- Treeselect
-- Tip: If you have set up remote text objects (`ar`/`ir`), `arn` will
-- work as expected (visit node).
vim.keymap.set({ 'x', 'o' }, 'an', function()
  require('leap.treesitter').select {
    opts = require('leap.user').with_traversal_keys('n', 'N')
  }
end)
