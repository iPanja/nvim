return {
	{ "mason-org/mason.nvim", version = "^1.0.0", opts = {} },
	{
		"mason-org/mason-lspconfig.nvim",
		version = "^1.0.0",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls" }, -- Add more servers here
				automatic_installation = true,
				auto_update = true,
				run_on_start = true,
			})
		end,
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"black",
					-- "prettier",
					-- add other tools here
				},
				auto_update = true, -- optional
				run_on_start = true, -- install missing on startup
			})
		end,
	},
}
