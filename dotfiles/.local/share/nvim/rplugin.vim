" perl plugins


" node plugins
call remote#host#RegisterPlugin('node', '/home/nonroot/.config/nvim/bundle/nvim-typescript/rplugin/node/nvim_typescript', [
     \ ])


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/nonroot/.config/nvim/bundle/deoplete.nvim/rplugin/python3/deoplete', [
      \ {'sync': v:false, 'name': '_deoplete_init', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


