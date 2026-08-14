-- Mason owns LSP server installation and lifecycle.
local ensure_installed = {
	"ruff",
	"pyright",
	"gopls",
	"clangd",
	"kotlin_language_server",
	"ltex",
	"taplo",
	"zk",
	"biome",
	"ts_ls",
	"cssls",
	"tailwindcss",
	"texlab",
	"jdtls",
	"rust_analyzer",
	"html",
	"lua_ls",
	"terraformls",
}

return {
	{
		"williamboman/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = ensure_installed,
			automatic_enable = true,
		},
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},
}
