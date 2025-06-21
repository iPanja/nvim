vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation level
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces for <Tab> while editing
vim.opt.smartindent = true -- Smart autoindenting on new lines
vim.opt.autoindent = true
vim.opt.smarttab = true

return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"html",
					"python",
					"typescript",
					"go",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					layout_strategy = "flex",
					layout_config = {
						horizontal = { preview_width = 0.6 },
						vertical = { preview_height = 0.5 },
					},
					sorting_strategy = "ascending",
					file_ignore_patterns = { "%.git/", "node_modules" },
				},
				pickers = {
					find_files = { hidden = true },
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Load extensions
			telescope.load_extension("fzf")

			-- Keybindings
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }

			keymap("n", "<leader>ff", builtin.find_files, opts) -- Find files
			keymap("n", "<leader>fg", builtin.live_grep, opts) -- Grep in project
			keymap("n", "<leader>fb", builtin.buffers, opts) -- Open buffers
			keymap("n", "<leader>fh", builtin.help_tags, opts) -- Help tags
			keymap("n", "<leader>fc", builtin.commands, opts) -- Available commands
			keymap("n", "<leader>fr", builtin.oldfiles, opts) -- Recent files
			keymap("n", "<leader>fd", builtin.diagnostics, opts) -- LSP diagnostics
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
}
