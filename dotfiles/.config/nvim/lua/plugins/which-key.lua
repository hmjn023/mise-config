-- Which-key v3 configuration
return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 300,
		spec = {
			{ "g", group = "navigation" },
			{ "<leader>g", group = "LSP / git" },
			{ "<leader>c", group = "code" },
			{ "<leader>f", group = "find / format" },
			{ "<leader>r", group = "rename" },
			{ "<leader>w", group = "workspace" },
			{ "<leader>x", group = "diagnostics" },
		},
	},
}
