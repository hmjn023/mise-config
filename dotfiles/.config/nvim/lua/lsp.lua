local opts = { noremap = true, silent = true }
--[[
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<space>f", function()
		vim.lsp.buf.format({ async = true })
	end, bufopts)
end
]]

local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "cmdline" },
		{ name = "git" },
		{ name = "vsnip" },
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	},
	experimental = {
		ghost_text = true,
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper function to find root directory
local function find_root(patterns)
	return function(fname)
		return vim.fs.root(fname, patterns)
	end
end

-- NOTE: This file uses the new vim.lsp.config API (Neovim 0.11+)
-- Configure LSP servers using vim.lsp.config instead of require('lspconfig')

vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = find_root({ "pyproject.toml", "setup.py", "requirements.txt", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = find_root({ "go.mod", "go.work", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.clangd = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_dir = find_root({ "compile_commands.json", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.kotlin_language_server = {
	cmd = { "kotlin-language-server" },
	filetypes = { "kotlin" },
	root_dir = find_root({ "settings.gradle", "build.gradle", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.ltex = {
	cmd = { "ltex-ls" },
	filetypes = { "tex", "bib", "markdown", "org", "rst" },
	root_dir = find_root({ ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.taplo = {
	cmd = { "taplo", "lsp", "stdio" },
	filetypes = { "toml" },
	root_dir = find_root({ ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.zk = {
	cmd = { "zk", "lsp" },
	filetypes = { "markdown" },
	root_dir = find_root({ ".zk" }),
	capabilities = capabilities,
}

vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_dir = find_root({ "package.json", "tsconfig.json", "jsconfig.json", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.cssls = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_dir = find_root({ "package.json", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.tailwindcss = {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	root_dir = find_root({ "tailwind.config.js", "tailwind.config.ts", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.texlab = {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib", "markdown" },
	root_dir = find_root({ ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.jdtls = {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_dir = find_root({ "pom.xml", "build.gradle", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = find_root({ "Cargo.toml", ".git" }),
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {},
	},
}

vim.lsp.config.html = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_dir = find_root({ "package.json", ".git" }),
	capabilities = capabilities,
}

vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_dir = find_root({ ".luarc.json", ".luarc.jsonc", ".git" }),
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.env.VIMRUNTIME,
			},
		},
	},
}

-- Enable all configured servers
local servers = {
	"pyright", "gopls", "clangd", "kotlin_language_server",
	"ltex", "taplo", "zk", "ts_ls", "cssls", "tailwindcss",
	"texlab", "jdtls", "rust_analyzer", "html", "lua_ls"
}

for _, server_name in ipairs(servers) do
	vim.lsp.enable(server_name)
end

-- Setup markdown fenced languages
vim.g.markdown_fenced_languages = {
	"ts=typescript",
	"js=javascript",
	"py=python",
	"lua=lua",
}

--[[
-- Emmet configuration (commented out)
-- To enable, uncomment and configure appropriately using vim.lsp.config.emmet_ls
vim.lsp.config.emmet_ls = {
	cmd = { "emmet-ls", "--stdio" },
	filetypes = {
		"css",
		"eruby",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"svelte",
		"pug",
		"typescriptreact",
		"vue",
	},
	capabilities = capabilities,
	init_options = {
		html = {
			options = {
				-- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
				["bem.enabled"] = true,
			},
		},
	},
}
vim.lsp.enable("emmet_ls")
]]
local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = gid,
	buffer = bufnr,
	callback = function()
		vim.lsp.buf.document_highlight()
	end,
})

vim.api.nvim_create_autocmd("CursorMoved", {
	group = gid,
	buffer = bufnr,
	callback = function()
		vim.lsp.buf.clear_references()
	end,
})
