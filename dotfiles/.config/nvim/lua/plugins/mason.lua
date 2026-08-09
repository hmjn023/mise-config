-- Mason LSP installer configuration
return {
	"williamboman/mason.nvim",
	config = function()
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		-- automatic_installation disabled: LSP servers managed via paru on Arch
		require("mason-lspconfig").setup({
			automatic_installation = false,
		})
	end,
}
