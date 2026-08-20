-- Fast, read-only previews for common reverse-engineering and CTF formats.
-- All external tools receive argv arrays; untrusted filenames never reach a shell.
local M = {}
local uv = vim.uv or vim.loop

local function to_lines(s)
  s = (s or ''):gsub('\r\n', '\n'):gsub('\n$', '')
  return s == '' and { '' } or vim.split(s, '\n', { plain = true })
end
local function run(argv, options)
  if vim.fn.executable(argv[1]) ~= 1 then return nil, 'Missing tool: ' .. argv[1] end
  local r = vim.system(argv, options or { text = true }):wait()
  if r.code ~= 0 then return nil, (r.stderr ~= '' and r.stderr or r.stdout) end
  return r.stdout or ''
end
local function first(cmds)
  for _, argv in ipairs(cmds) do if vim.fn.executable(argv[1]) == 1 then return run(argv) end end
  return nil, 'Install one of: ' .. table.concat(vim.tbl_map(function(v) return v[1] end, cmds), ', ')
end
local function render(buf, text, ft)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, to_lines(text))
  vim.bo[buf].filetype, vim.bo[buf].buftype, vim.bo[buf].swapfile = ft or 'text', 'nofile', false
  vim.bo[buf].modified, vim.bo[buf].readonly, vim.bo[buf].modifiable = false, true, false
end
local function path()
  local p = vim.api.nvim_buf_get_name(0)
  if p == '' or p:match('^reverse://') then vim.notify('No input file', vim.log.levels.ERROR); return end
  return vim.fn.fnamemodify(p, ':p')
end
local function inspect(name, fn, ft)
  local p = path(); if not p then return end
  local out, err = fn(p); if not out then vim.notify(err, vim.log.levels.ERROR); return end
  vim.cmd.new(); local b = vim.api.nvim_get_current_buf()
  pcall(vim.api.nvim_buf_set_name, b, 'reverse://' .. name .. '/' .. vim.fn.fnamemodify(p, ':t'))
  render(b, out, ft)
end
local function magic(p, value)
  local fd = uv.fs_open(p, 'r', 438); if not fd then return false end
  local got = uv.fs_read(fd, #value, 0); uv.fs_close(fd); return got == value
end
local function entropy(p)
  local fd, err = uv.fs_open(p, 'r', 438); if not fd then return nil, tostring(err) end
  local out, offset = { 'OFFSET      SIZE  ENTROPY' }, 0
  while true do
    local data = uv.fs_read(fd, 4096, offset); if not data or #data == 0 then break end
    local counts, e = {}, 0
    for i = 1, #data do local b = data:byte(i); counts[b] = (counts[b] or 0) + 1 end
    for _, n in pairs(counts) do local q = n / #data; e = e - q * math.log(q) / math.log(2) end
    out[#out + 1] = ('0x%08x  %4d  %.4f %s'):format(offset, #data, e, string.rep('#', math.floor(e * 5 + .5)))
    offset = offset + #data
  end
  uv.fs_close(fd); return table.concat(out, '\n')
end

vim.api.nvim_create_user_command('ReverseFileInfo', function() inspect('file', function(p)
  local a, e = run({ 'file', '-b', p }); if not a then return nil, e end
  local b, e2 = run({ 'file', '-b', '--mime-type', '--mime-encoding', p })
  return b and a:gsub('\n$', '') .. '\n' .. b or nil, e2
end, 'text') end, {})
vim.api.nvim_create_user_command('ReverseHex', function() inspect('hex', function(p)
  return first({ { 'xxd', '-g', '1', p }, { 'od', '-Ax', '-tx1z', '-v', p } })
end, 'xxd') end, {})
vim.api.nvim_create_user_command('ReverseStrings', function() inspect('strings', function(p)
  return run({ 'strings', '-a', '-n', '4', p }) end, 'text') end, {})
vim.api.nvim_create_user_command('ReverseEntropy', function() inspect('entropy', entropy, 'text') end, {})
vim.api.nvim_create_user_command('ReverseBinwalk', function() inspect('binwalk', function(p)
  return run({ 'binwalk', p }) end, 'text') end, {})

local group = vim.api.nvim_create_augroup('ExReverseEngineering', { clear = true })
local function au(pattern, cb, event)
  vim.api.nvim_create_autocmd(event or { 'BufReadPost', 'FileReadPost' }, { group = group, pattern = pattern, callback = cb })
end
local function command(builder, ft, guard)
  return function(a)
    local p = vim.fn.fnamemodify(a.file, ':p'); if guard and not guard(p) then return end
    local out, err = first(builder(p)); render(a.buf, out or err, ft)
  end
end
au('*.class', command(function(p) return { { 'procyon', p }, { '/usr/local/bin/procyon', p } } end, 'java'))
au('*.wasm', command(function(p) return { { 'wasm-decompile', p }, { '/usr/local/bin/wasm-decompile', p } } end, 'wasm'))
au({ '*.pyc', '*.pyo' }, command(function(p) return { { 'decompyle3', p }, { '/usr/local/bin/decompyle3', p } } end, 'python'))
au({ '*.jpg', '*.jpeg', '*.png', '*.gif', '*.bmp', '*.tiff', '*.webp' }, command(function(p)
  return { { 'exiftool', '-a', '-u', '-g1', p } } end, 'text'))
-- .bin is deliberately generic; ELF extensions are still magic-checked.
au({ '*.o', '*.so', '*.ko', '*.elf' }, command(function(p) return {
  { 'objdump', '-M', 'intel', '--visualize-jumps', '--disassemble-all', p }, { 'llvm-objdump-16', '-d', p }
} end, 'nasm', function(p) return magic(p, '\127ELF') end))
-- .pyd is a PE native extension, not Python bytecode. Detect managed PE first.
au({ '*.exe', '*.dll', '*.sys', '*.scr', '*.cpl', '*.pyd' }, function(a)
  local p = vim.fn.fnamemodify(a.file, ':p'); local kind = run({ 'file', '-b', p }) or ''
  local cmds, ft
  if kind:match('Mono/.Net') or kind:match('%.NET') then cmds, ft = { { 'ilspycmd', p }, { 'monodis', p } }, 'cs'
  else cmds, ft = { { 'objdump', '-x', '-d', '-M', 'intel', p }, { 'llvm-objdump-16', '-p', '-d', p }, { 'rabin2', '-I', '-S', '-s', p } }, 'nasm' end
  local out, err = first(cmds); render(a.buf, out or err, ft)
end)
au({ '*.dylib', '*.macho' }, command(function(p) return { { 'llvm-objdump-16', '--macho', '--disassemble', p }, { 'llvm-otool-16', '-tvV', p } } end, 'nasm'))
au({ '*.odex', '*.vdex' }, command(function(p) return { { 'baksmali', 'dump', p }, { 'jadx', '--show-bad-code', p } } end, 'smali'))
au('*.pdf', command(function(p) return { { 'pdftotext', '-htmlmeta', p, '-' } } end, 'html'))
au({ '*.sqlite', '*.sqlite3', '*.db' }, function(a)
  local p = vim.fn.fnamemodify(a.file, ':p'); if not magic(p, 'SQLite format 3\0') then return end
  local out, err = run({ 'sqlite3', p, '.dump' }); render(a.buf, out or err, 'sql')
end)
au({ '*.pcap', '*.cap', '*.pcapng' }, command(function(p) return { { 'tshark', '-n', '-r', p,
  '-T', 'fields', '-E', 'header=y', '-e', 'frame.number', '-e', 'frame.time_relative', '-e', '_ws.col.Source',
  '-e', '_ws.col.Destination', '-e', '_ws.col.Protocol', '-e', 'frame.len', '-e', '_ws.col.Info' } } end, 'pcap'))
local function package(meta, list, ft) return function(a)
  local p = vim.fn.fnamemodify(a.file, ':p'); local x, xe = run(meta(p)); local y, ye = run(list(p))
  render(a.buf, table.concat({ x or xe, '', 'Files:', y or ye }, '\n'), ft)
end end
au('*.deb', package(function(p) return { 'dpkg-deb', '-I', p } end, function(p) return { 'dpkg-deb', '-c', p } end, 'deb'), 'BufReadCmd')
au('*.rpm', package(function(p) return { 'rpm', '-qip', p } end, function(p) return { 'rpm', '-qlp', p } end, 'rpm'), 'BufReadCmd')

-- Listing/metadata only: BufReadCmd avoids loading large containers and never extracts them.
au({ '*.zip', '*.tar', '*.tar.gz', '*.tgz', '*.tar.xz', '*.tar.bz2', '*.7z', '*.rar', '*.aab', '*.xapk',
  '*.docx', '*.xlsx', '*.pptx', '*.odt' }, command(function(p) return {
  { 'bsdtar', '-tvf', p }, { '7z', 'l', p }, { 'unzip', '-l', p }
} end, 'text'), 'BufReadCmd')
au({ '*.img', '*.fw', '*.rom', '*.ubi', '*.iso', '*.qcow2', '*.vmdk' }, command(function(p)
  return { { 'binwalk', p }, { 'file', '-b', p } } end, 'text'), 'BufReadCmd')
au({ '*.mp3', '*.wav', '*.mp4', '*.mkv', '*.avi' }, command(function(p)
  return { { 'ffprobe', '-v', 'quiet', '-show_format', '-show_streams', p } } end, 'ini'), 'BufReadCmd')
au({ '*.pb', '*.proto.bin' }, command(function(p) return { { 'protoc', '--decode_raw', p } } end, 'text'))
au({ '*.der', '*.asn1' }, command(function(p) return { { 'openssl', 'asn1parse', '-inform', 'DER', '-i', '-in', p } } end, 'text'))

-- JARs and APKs are extracted into an isolated temporary directory, then handed to the
-- configured directory explorer (netrw, oil.nvim, neo-tree, etc.).
au({ '*.jar', '*.apk' }, function(a)
  local jar = vim.fn.fnamemodify(a.file, ':p')
  local destination = vim.fn.tempname() .. '-' .. vim.fn.fnamemodify(jar, ':t:r')
  local ok, mkdir_err = uv.fs_mkdir(destination, 448)
  if not ok then
    render(a.buf, 'Unable to create temporary directory:\n' .. tostring(mkdir_err), 'text')
    return
  end

  local _, extract_err = run({ 'unzip', '-q', jar, '-d', destination })
  if extract_err then
    render(a.buf, 'Unable to extract JAR:\n' .. extract_err, 'text')
    return
  end

  vim.bo[a.buf].bufhidden = 'wipe'
  vim.schedule(function()
    vim.cmd.edit(vim.fn.fnameescape(destination))
  end)
end, 'BufReadCmd')

-- Convert DEX bytecode to a JAR, extract it, and browse the resulting classes.
au('*.dex', function(a)
  local dex = vim.fn.fnamemodify(a.file, ':p')
  local workspace = vim.fn.tempname() .. '-' .. vim.fn.fnamemodify(dex, ':t:r')
  local extracted = workspace .. '/extracted'
  local jar = workspace .. '/classes.jar'

  local ok, mkdir_err = uv.fs_mkdir(workspace, 448)
  if ok then ok, mkdir_err = uv.fs_mkdir(extracted, 448) end
  if not ok then
    render(a.buf, 'Unable to create temporary directory:\n' .. tostring(mkdir_err), 'text')
    return
  end

  local _, convert_err = first({
    { 'd2j-dex2jar', '-f', '-o', jar, dex },
    { 'dex2jar', '-f', '-o', jar, dex },
  })
  if convert_err then
    render(a.buf, 'Unable to convert DEX to JAR:\n' .. convert_err, 'text')
    return
  end

  local _, extract_err = run({ 'unzip', '-q', jar, '-d', extracted })
  if extract_err then
    render(a.buf, 'Unable to extract converted JAR:\n' .. extract_err, 'text')
    return
  end

  vim.bo[a.buf].bufhidden = 'wipe'
  vim.schedule(function()
    vim.cmd.edit(vim.fn.fnameescape(extracted))
  end)
end, 'BufReadCmd')

-- JAR class preview without shell interpolation or extraction into the repository.
au('zipfile://*.class', function(a)
  local jar, class = a.file:match('^zipfile://(.*)::(.*)$'); if not jar then return end
  local bytes, err = run({ 'unzip', '-p', jar, class }, { text = false }); if not bytes then vim.notify(err, vim.log.levels.ERROR); return end
  local tmp = vim.fn.tempname() .. '.class'; local fd = assert(uv.fs_open(tmp, 'w', 384))
  uv.fs_write(fd, bytes, 0); uv.fs_close(fd)
  local out, e = first({ { 'procyon', tmp }, { '/usr/local/bin/procyon', tmp } }); uv.fs_unlink(tmp)
  scratch('class/' .. vim.fn.fnamemodify(class, ':t'), out or e, 'java')
end, 'BufReadCmd')
M.entropy = entropy
return M
