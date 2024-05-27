-- ---------
-- lualine theme
-- ---------
require('lualine').setup({
    options = {
        globalstatus = true,
        theme = 'terafox'
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{'filename', file_status = true, path = 1}},
        lualine_x = {'encoding', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
})
