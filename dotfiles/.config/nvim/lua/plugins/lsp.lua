-- LSP configuration
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- Global variable to toggle auto-formatting (read by conform.nvim)
		vim.g.auto_format_enabled = false

		-- Use LspAttach event to setup keymaps for all LSP servers
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				local bufnr = ev.buf

				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

				local bufopts = { noremap = true, silent = true, buffer = bufnr }

				-- LSP navigation
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

				-- Workspace management
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)

				-- Code actions and navigation
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

				-- Document highlight
				if client and client.server_capabilities.documentHighlightProvider then
					local gid = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
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
				end
			end,
		})

		-- Setup completion capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Configure diagnostic display
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
			float = {
				source = "always",
				border = "rounded",
				header = "",
				prefix = "",
				focusable = false,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})

		-- Auto show diagnostics on cursor hold
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				local opts = {
					focusable = false,
					close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
					border = "rounded",
					source = "always",
					prefix = " ",
					scope = "cursor",
				}
				vim.diagnostic.open_float(nil, opts)
			end,
		})

		vim.opt.updatetime = 300

		-- Helper function to find root directory
		local function find_root(patterns)
			return function(fname)
				return vim.fs.root(fname, patterns)
			end
		end

		-- LSP server configurations using vim.lsp.config API (Neovim 0.11+)
		vim.lsp.config.ruff = {
			cmd = { "ruff", "server" },
			filetypes = { "python" },
			root_dir = find_root({ "pyproject.toml", "setup.py", "requirements.txt", ".git" }),
			capabilities = capabilities,
			settings = {
				args = {},
				lineLength = 88,
				lint = { enable = true, select = { "ALL" } },
				format = { enable = true },
			},
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

		vim.lsp.config.biome = {
			cmd = { "biome", "lsp-proxy" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "html", "css", "vue" },
			root_dir = find_root({ "biome.json", "biome.jsonc", ".git" }),
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
				["rust-analyzer"] = {
					checkOnSave = { command = "clippy" },
				},
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
					runtime = { version = "LuaJIT" },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					diagnostics = { globals = { "vim" }, enable = true },
					format = { enable = true },
					telemetry = { enable = false },
				},
			},
		}

		vim.lsp.config.terraformls = {
			cmd = { "terraform-ls", "serve" },
			filetypes = { "terraform", "terraform-vars" },
			root_dir = find_root({ ".terraform", ".git" }),
			capabilities = capabilities,
		}

		local servers = {
			"ruff", "gopls", "clangd", "kotlin_language_server",
			"ltex", "taplo", "zk", "biome", "cssls", "tailwindcss",
			"texlab", "jdtls", "rust_analyzer", "html", "lua_ls",
			"terraformls",
		}
		for _, server_name in ipairs(servers) do
			vim.lsp.enable(server_name)
		end

		vim.filetype.add({
			extension = {
				tf = "terraform",
				tfvars = "terraform-vars",
				tfstate = "json",
			},
		})

		vim.g.markdown_fenced_languages = {
			"ts=typescript",
			"js=javascript",
			"py=python",
			"lua=lua",
		}

		-- Toggle auto-format on save: <leader><space><space>
		vim.keymap.set("n", "<leader><space><space>", function()
			vim.g.auto_format_enabled = not vim.g.auto_format_enabled
			print("Auto-format " .. (vim.g.auto_format_enabled and "enabled" or "disabled"))
		end, { noremap = true, silent = true, desc = "Toggle auto-format on save" })
	end,
}
