-- snacks.nvim: quality-of-life collection (folke)
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- Disable heavy features for large files
		bigfile = { enabled = true },
		-- Indent guides
		indent = { enabled = true },
		-- Highlight all occurrences of word under cursor
		words = { enabled = true },
		-- Scratch buffers
		scratch = { enabled = true },
	},
	keys = {
		{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
	},
}
