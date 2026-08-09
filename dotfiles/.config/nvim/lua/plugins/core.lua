-- Core plugins without specific configuration
return {
	-- Lua dev environment (replaces neoconf + neodev)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	"onsails/lspkind.nvim",
	"windwp/nvim-ts-autotag",
	"andymass/vim-matchup",
	"goolord/alpha-nvim",
	"EdenEast/nightfox.nvim",

	-- Language specific
	"mfussenegger/nvim-jdtls",
	"solidjs-community/solid-snippets",

	-- Visual multi-cursor
	{
		"mg979/vim-visual-multi",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
	},

	-- Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
}
