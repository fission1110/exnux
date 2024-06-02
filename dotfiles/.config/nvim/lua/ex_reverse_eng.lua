-- A module that provides a simple way to reverse engineer various filetypes.
-- For example, if you load a java .class file, it will be sent to a decompiler
-- and the decompiled code will be displayed in the buffer.

local function class()
  -- Auto decompile the class file
  vim.cmd('%!/usr/local/bin/procyon %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'java'
  vim.bo.swapfile = false
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*.class',
  callback = class
})

local function wasm()
  -- Auto decompile the wasm file
  vim.cmd('%!/usr/local/bin/wasm-decompile %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'wasm'
  vim.bo.swapfile = false
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*.wasm',
  callback = wasm
})

local function pyc()
  -- Auto decompile the pyc file
  vim.cmd('%!/usr/local/bin/decompyle3 %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.filetype = 'python'
  vim.bo.swapfile = false
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = { '*.pyc', '*.pyo', '*.pyd' },
  callback = pyc
})

local function img()
  -- Auto open the image file
  vim.cmd('%!/usr/bin/exiftool %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = { '*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.webp' },
  callback = img
})

local function elf()
  -- Auto open the elf file
  vim.cmd('%!/usr/bin/objdump -M intel --visualize-jumps --disassemble-all  %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'nasm'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = { '*.o', '*.so', '*.ko', '*.elf', '*.bin' },
  callback = elf
})

local function deb()
  -- Auto open the deb file
  local metainfo = vim.fn.systemlist('/usr/bin/dpkg-deb -I ' .. vim.fn.expand('%:p'))
  local files = vim.fn.systemlist('/usr/bin/dpkg-deb -c ' .. vim.fn.expand('%:p'))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, metainfo)
  -- Add file list
  vim.api.nvim_buf_set_lines(0, #metainfo + 1, -1, false, files)
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'deb'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*.deb',
  callback = deb
})

local function rpm()
  -- Auto open the rpm file
  local metainfo = vim.fn.systemlist('/usr/bin/rpm -qip ' .. vim.fn.expand('%:p'))
  local files = vim.fn.systemlist('/usr/bin/rpm -qlp ' .. vim.fn.expand('%:p'))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, metainfo)
  -- Add file list
  vim.api.nvim_buf_set_lines(0, #metainfo + 1, -1, false, files)
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'rpm'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*.rpm',
  callback = rpm
})

local function pdf()
  -- Auto open the pdf file
  vim.cmd('%!/bin/pdftotext -htmlmeta % -')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'html'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = '*.pdf',
  callback = pdf
})

local function sqlite()
  -- Auto open the sqlite file
  vim.cmd('%!/usr/bin/sqlite3 % .dump')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'sql'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = { '*.sqlite', '*.db', '*.sqlite3' },
  callback = sqlite
})

local function pcap()
  -- Auto open the pcap file
  -- Show wireshark gui columns
  vim.cmd('%!/usr/bin/tshark -o \'gui.column.format:"No.","\\%m","Time","\\%t","Source","\\%s","Destination","\\%d","Protocol","\\%p","Length","\\%L","Info","\\%i"\' -r %')
  vim.bo.readonly = true
  vim.bo.modifiable = false
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'pcap'
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'FileReadPost' }, {
  pattern = { '*.pcap', '*.cap', '*.pcapng' },
  callback = pcap
})

local function jar()
  -- This one is a bit more complicated, we need to extract the .class files from the jar file
  -- and then decompile them
  -- We rely on the zip functionality of vim to view the contents of the jar file
  -- and when we select a class file, we extract to a tmp directory, decompile it and open it in a buffer
  -- First we need the buffer name of the <afile> file
  -- Because of how the zip functionality works, we have to hook into the BufReadCmd event
  -- then extract the class into a new window, and jump back to the original window
  local zip_filename = vim.fn.expand('%:p')
  -- The zip_filename looks like zipfile:///path/to/file.jar::file.class
  -- We need to extract the path to the jar file and the class file
  local jar_filename, class_filename = zip_filename:match('zipfile://(.*)::(.*)')
  -- Create a tmpname for the extracted class file
  local tmpname = vim.fn.tempname() .. '.class'
  -- Extract the class file from the jar file
  vim.cmd('!unzip -p ' .. jar_filename .. ' ' .. class_filename .. ' > ' .. tmpname)

  -- Auto decompile the class file
  local decompiled = vim.system({ '/usr/local/bin/procyon', tmpname }, { text = true }):wait()

  -- Create a new buffer and display the decompiled code
  local bufnr = vim.fn.bufnr('%')
  local winnr = vim.fn.bufwinnr(bufnr)

  vim.cmd('new')
  -- write the decompiled code to the buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(decompiled.stdout, '\n'))
  vim.bo.buftype = 'nofile'
  vim.bo.swapfile = false
  vim.bo.filetype = 'java'
  vim.bo.readonly = true
  vim.bo.modifiable = false

  -- Make the buffer the same size as the original buffer
  vim.cmd("wincmd _")

  -- Jump to the original window to let the zip function finish processing
  vim.cmd(winnr .. 'wincmd w')
end

vim.api.nvim_create_autocmd({ 'BufReadCmd' }, {
  pattern = 'zipfile://*.class',
  callback = jar
})
