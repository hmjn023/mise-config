-- LSP configuration
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
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

				-- LSP navigation and symbol operations
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, {
					desc = "LSP: declaration",
				}))
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, {
					desc = "LSP: definition",
				}))
				-- Python LSP servers commonly do not implement
				-- textDocument/implementation. Only expose this mapping when the
				-- attached server actually supports it, avoiding a misleading warning.
				if client and client:supports_method("textDocument/implementation") then
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, {
						desc = "LSP: implementation",
					}))
					vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, {
						desc = "LSP: implementation",
					}))
				end
				vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, {
					desc = "LSP: references",
				}))
				vim.keymap.set("n", "gO", vim.lsp.buf.document_symbol, vim.tbl_extend("force", bufopts, {
					desc = "LSP: document symbols",
				}))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, {
					desc = "LSP: hover",
				}))
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", bufopts, {
					desc = "LSP: signature help",
				}))
				vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, vim.tbl_extend("force", bufopts, {
					desc = "LSP: workspace symbols",
				}))

				-- Workspace management
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", bufopts, {
					desc = "LSP: add workspace folder",
				}))
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", bufopts, {
					desc = "LSP: remove workspace folder",
				}))
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, vim.tbl_extend("force", bufopts, {
					desc = "LSP: list workspace folders",
				}))

				-- Code actions and navigation
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", bufopts, {
					desc = "LSP: type definition",
				}))
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, {
					desc = "LSP: rename symbol",
				}))
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, {
					desc = "LSP: code action",
				}))

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
			return function(bufnr, on_dir)
				local root = vim.fs.root(bufnr, patterns)
				if root then
					on_dir(root)
				end
			end
		end

		-- LSP server configurations using vim.lsp.config API (Neovim 0.11+).
		-- mason-lspconfig installs and enables only the servers managed by Mason.
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

		vim.lsp.config.biome = {
			cmd = { "biome", "lsp-proxy" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc", "html", "css", "vue" },
			root_dir = find_root({ "biome.json", "biome.jsonc", ".git" }),
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
