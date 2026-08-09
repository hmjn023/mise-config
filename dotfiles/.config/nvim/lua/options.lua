-- Basic vim options
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.mouse = "a"
vim.opt.splitright = true
vim.opt.completeopt = "menuone,noinsert"
vim.opt.pumblend = 20
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

-- Neovide specific options
if vim.g.neovide then
	vim.g.neovide_fullscreen = false
	vim.g.neovide_input_ime = true
	vim.g.neovide_transparency = 0.8
end