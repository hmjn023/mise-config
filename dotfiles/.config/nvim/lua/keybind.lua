-- Neovim 0.11+ modern keymap API
local opts = { noremap = true, silent = true }

-- File tree and navigation
vim.keymap.set("n", "<C-f>", "<cmd>Neotree toggle<CR>", opts)
vim.keymap.set("n", "<Leader>ff", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<Leader>fg", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope buffers<CR>", opts)
vim.keymap.set("n", "<Leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Buffer navigation
vim.keymap.set("n", "<C-l>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<C-h>", "<cmd>bprev<CR>", opts)

-- Aerial (code outline)
vim.keymap.set("n", "<Leader>a", "<cmd>AerialToggle!<CR>", opts)

-- Terminal
vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<CR>", opts)
vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<CR>", opts)

-- Split window
vim.keymap.set("n", "<Leader>ss", "<cmd>vsplit<CR>", opts)
vim.keymap.set("n", "<Leader>sh", "<cmd>split<CR>", opts)

-- Format (conform with LSP fallback)
vim.keymap.set("n", "<Leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, opts)

-- LSP keymaps (these will be set up in lsp.lua)
-- Global diagnostic mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Git navigation (gitsigns.nvim will override these with proper hunk navigation)
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		vim.cmd.normal({']c', bang = true})
	else
		require('gitsigns').next_hunk()
	end
end, opts)

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		vim.cmd.normal({'[c', bang = true})
	else
		require('gitsigns').prev_hunk()
	end
end, opts)

-- Git actions
vim.keymap.set("n", "<Leader>gp", "<cmd>Gitsigns preview_hunk<CR>", opts)
vim.keymap.set("n", "<Leader>gb", "<cmd>Gitsigns blame_line<CR>", opts)

-- Trouble (diagnostics)
vim.keymap.set("n", "<Leader>xx", "<cmd>Trouble diagnostics toggle<CR>", opts)
vim.keymap.set("n", "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", opts)
vim.keymap.set("n", "<Leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", opts)
vim.keymap.set("n", "<Leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", opts)
vim.keymap.set("n", "<Leader>xL", "<cmd>Trouble loclist toggle<CR>", opts)
vim.keymap.set("n", "<Leader>xQ", "<cmd>Trouble qflist toggle<CR>", opts)
