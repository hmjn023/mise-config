-- Telescope configuration
return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-frecency.nvim",
		"nvim-telescope/telescope-media-files.nvim",
	},
	config = function()
		require("telescope").setup({
			extensions = {
				media_files = {
					filetypes = { "png", "webp", "jpg", "jpeg" },
					find_cmd = "rg", -- find command (defaults to `fd`)
				},
			},
		})
		require("telescope").load_extension("media_files")
	end,
}