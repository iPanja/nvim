-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = "yes"

-- Run conform (linting/formatting) automatically on file (buffer) save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(event)
		local buf = event.buf
		local conform = require("conform")
		conform.format({ async = false, buffer = buf })
	end,
})

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf }
		-- Attach navic if available
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentSymbolProvider then
			local navic_ok, navic = pcall(require, "nvim-navic")
			if navic_ok then
				navic.attach(client, event.buf)
			end
		end

		vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>",{ buffer = event.buf, desc = "Hover documentation"})
		vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { buffer = event.key, desc = "Go to definition"})
		vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { buffer = event.key, desc = "Go to declaration"})
		vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { buffer = event.key, desc = "Go to implementation"})
		vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", { buffer = event.key, desc = "Go to type definition"})
		vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { buffer = event.key, desc = "Find references"})
		vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { buffer = event.key, desc = "Signature help"})
		vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", { buffer = event.key, desc = "Rename symbol"})
		vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", { buffer = event.key, desc = "Format buffer"})
		vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", { buffer = event.key, desc = "Code action"})
	end,
})

return {
	-- LSP config
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- Add cmp_nvim_lsp capabilities settings to lspconfig
			-- This should be executed before you configure any language server
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
					})
				end,
				-- Custom handler for lua_ls
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
				-- Custom handler for gopls
				["gopls"] = function()
					lspconfig.gopls.setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
						settings = {
							gopls = {
								analyses = {
									shadow = true,
									unusedparams = true,
								},
								staticcheck = true,
							},
						},
					})
				end,
				-- Custom handler for pyright
				["pyright"] = function()
					lspconfig.pyright.setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
						settings = {
							pyright = {
								analysis = {
									typeCheckingMode = "basic",
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace",
								},
							},
						},
					})
				end,
				-- Custom handler for ts_ls (formerly tsserver)
				["ts_ls"] = function()
					lspconfig.ts_ls.setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
							javascript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
					})
				end,
				-- Custom handler for clangd
				["clangd"] = function()
					lspconfig.clangd.setup({
						capabilities = cmp_nvim_lsp.default_capabilities(),
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--header-insertion=iwyu",
							"--completion-style=detailed",
							"--function-arg-placeholders",
							"--fallback-style=llvm",
							-- "--log=verbose",
						},
						init_options = {
							usePlaceholders = true,
							completeUnimported = true,
							clangdFileStatus = true,
						},
						root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
					})
				end,
			})
		end,
	},

	-- Autocompletion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = {
					{ name = "nvim_lsp" },
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					go = { "gofmt" },
					python = { "black", "isort" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					markdown = { "prettier" },
				},
				log_level = vim.log.levels.INFO,
			})
		end,
	},
}
