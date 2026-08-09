-- Treesitter configuration (new API post-rewrite)
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			auto_install = true,
			-- "vim" and "vimdoc" excluded: Neovim 0.11+ ships these in
			-- /usr/lib/nvim/parser/ and its runtime queries target that version.
			-- Installing via nvim-treesitter causes a parser/query mismatch.
			ensure_installed = {
				"lua", "query",
				"javascript", "typescript", "tsx",
				"python", "rust", "go", "java",
				"html", "css", "json", "yaml", "toml",
				"markdown", "bash",
				"terraform", "hcl",
			},
		})
	end,
}
