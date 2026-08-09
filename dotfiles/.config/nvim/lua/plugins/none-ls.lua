-- conform.nvim: lightweight formatter (replaces none-ls)
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				scss = { "prettier" },
				markdown = { "prettier" },
				terraform = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
			},
			format_on_save = function()
				if vim.g.auto_format_enabled then
					return { timeout_ms = 500, lsp_format = "fallback" }
				end
			end,
		})

		-- Manual format: <leader><space>
		vim.keymap.set("n", "<leader><space>", function()
			require("conform").format({ async = false, lsp_format = "fallback" })
		end, { noremap = true, silent = true, desc = "Format buffer" })
	end,
}
