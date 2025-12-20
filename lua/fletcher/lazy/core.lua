-- Auto read when file is changed outside of vim
vim.opt.autoread = true

-- Trigger autoread when changing buffers or coming  back to vim
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI"}, {
	pattern = "*",
	command = "checktime"
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces for each indentation level
vim.opt.tabstop = 4 -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 4 -- Number of spaces for <Tab> while editing
vim.opt.smartindent = true -- Smart autoindenting on new lines
vim.opt.autoindent = true
vim.opt.smarttab = true

vim.opt.clipboard = "unnamedplus" -- use system keyboard for yank

vim.opt.nu = true -- set line numbers -- set line numbers
vim.opt.relativenumber = true -- use relative line numbers

vim.opt.wrap = false

vim.opt.incsearch = true -- incremental search

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		-- event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"javascript",
					"typescript",
					"tsx",
					"html",
					"css",
					"json",
					"yaml",
					"python",
					"go",
					"c",
					"cpp",
					"markdown",
					"markdown_inline",
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

			keymap("n", "<leader>ff", builtin.find_files, { noremap = true, silent = true, desc = "Find files" })
			keymap("n", "<leader>fg", builtin.live_grep, { noremap = true, silent = true, desc = "Live grep" })
			keymap("n", "<leader>fb", builtin.buffers, { noremap = true, silent = true, desc = "Open buffers" })
			keymap("n", "<leader>fh", builtin.help_tags, { noremap = true, silent = true, desc = "Help tags" })
			keymap("n", "<leader>fc", builtin.commands, { noremap = true, silent = true, desc = "Available commands" })
			keymap("n", "<leader>fr", builtin.oldfiles, { noremap = true, silent = true, desc = "Recent files" })
			keymap("n", "<leader>fd", builtin.diagnostics, { noremap = true, silent = true, desc = "LSP diagnostics" })
		end,
	},
	{
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
}
