-- Other plugin configurations
return {
	-- Auto pairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Code outline
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},

	-- Image preview
	{
		"adelarsq/image_preview.nvim",
		config = function()
			require("image_preview").setup()
		end,
	},

	-- Link visitor
	{
		"xiyaowong/link-visitor.nvim",
		config = function()
			require("link-visitor").setup({
				open_cmd = "xdg-open",
				silent = true,
				skip_confirmation = false,
				border = "rounded",
			})
		end,
	},
}
