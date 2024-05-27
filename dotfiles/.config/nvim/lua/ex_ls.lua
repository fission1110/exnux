-- get $USERNAME environment variable
local username = os.getenv("USERNAME")
local ls = require("luasnip")

require("luasnip.loaders.from_snipmate").lazy_load({paths = {"/home/" .. username .. "/.config/nvim/snippets"}})
vim.keymap.set({"i"}, "<C-L>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-]>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-[>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
