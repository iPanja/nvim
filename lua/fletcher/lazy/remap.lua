-- Set key binds via vim.keymap.set()
-- which-key will display them automatically. which-key.register() does not create keybinds, only displays them.
-- -- Use vim.keymap.set to define each
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- WINDOW NAVIGATION
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- WINDOW RESIZING
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- SPLIT WINDOWS
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- TABS (if you use tabs)
keymap("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>to", ":tabonly<CR>", { desc = "Close all other tabs" })
keymap("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })

-- BUFFER NAVIGATION
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })

-- FILE EXPLORER (NetRW or user-defined)
keymap("n", "<leader>e", "<cmd>Vex<CR>", { desc = "File explorer (vertical)" })

-- TOGGLE COMMENTS
---- NORMAL mode: toggle comment on current line
vim.keymap.set("n", "<leader>/", function()
	require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment (line)" })

---- VISUAL mode: toggle comment on selected lines
vim.keymap.set("v", "<leader>/", function()
	local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)
	require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle comment (selection)" })

return {}
