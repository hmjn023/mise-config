-- Treesitter configuration (new API post-rewrite)
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		-- Neovim ships parsers and matching queries for its own Tree-sitter ABI.
		-- Keep the system Lua parser ahead of nvim-treesitter's downloaded copy;
		-- otherwise the runtime Lua query can reference fields that the older
		-- downloaded parser does not have.
		local runtime_lua_parser = vim.fs.joinpath(vim.env.VIMRUNTIME, "parser", "lua.so")
		if vim.uv.fs_stat(runtime_lua_parser) then
			vim.treesitter.language.add("lua", { path = runtime_lua_parser })
		end

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
