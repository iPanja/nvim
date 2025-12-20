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

-- Bracket-based window navigation
keymap("n", "]w", "<C-w>w", { desc = "Next window" })
keymap("n", "[w", "<C-w>W", { desc = "Previous window" })
keymap("n", "[W", "999<C-w>h", { desc = "Leftmost window" })
keymap("n", "]W", "999<C-w>l", { desc = "Rightmost window" })

-- WINDOW RESIZING
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- SPLIT WINDOWS
keymap("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap("n", "<leader>sx", ":close<CR>", { desc = "Close current split/pane" })
keymap("n", "<leader>so", ":only<CR>", { desc = "Close all other splits" })

-- TABS (if you use tabs)
keymap("n", "<leader>to", ":tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>tO", ":tabonly<CR>", { desc = "Close all other tabs" })
keymap("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })

-- BRACKET-BASED TAB NAVIGATION
keymap("n", "]t", ":tabnext<CR>", { desc = "Next tab" })
keymap("n", "[t", ":tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "[T", "999<C-w>h", { desc = "Leftmost tab" })
keymap("n", "]T", "999<C-w>l", { desc = "Rightmost tab" })

-- BUFFER NAVIGATION
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", function()
	-- If there are multiple buffers, switch to previous before deleting
	local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })
	if buf_count > 1 then
		vim.cmd("bprevious")
	end
	vim.cmd("bdelete #")
end, { desc = "Close buffer" })

keymap("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force close buffer" })
keymap("n", "<leader>ba", ":%bdelete<CR>", { desc = "Close all buffers" })
keymap("n", "<leader>bo", ":%bdelete|edit #|bdelete #<CR>", { desc = "Close all but current buffer" })
keymap("n", "<leader>br", ":e<CR>", { desc = "Reload buffer from disk" })
keymap("n", "<leader>bR", ":e!<CR>", { desc = "Force reload (discard changes)" })

-- BRACKET-BASED BUFFER NAVIGATION
keymap("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "[B", ":blast<CR>", { desc = "Last buffer" })
keymap("n", "]B", ":bfirst<CR>", { desc = "First buffer" })

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

-- INDENTATION
---- Indent
keymap("n", "<D-]>", ">>", { desc = "Indent line" })
keymap("v", "<D-]>", ">gv", { desc = "Indent selection" })
---- Unindent
keymap("n", "<D-[>", "<<", { desc = "Un-indent line" })
keymap("v", "<D-[>", "<gv", { desc = "Un-indent selection" })

-- DIAGNOSTIC NAVIGATION (LSP errors/warnings)
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
keymap("n", "[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })

keymap("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
keymap("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- QUICKFIX LIST NAVIGATION
keymap("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item" })
keymap("n", "]Q", ":clast<CR>", { desc = "Last quickfix list" })
keymap("n", "[Q", ":cfirst<CR>", { desc = "First quickfix list" })

-- LOCATION LIST NAVIGATION
keymap("n", "]l", ":lnext<CR>", { desc = "Next location list item" })
keymap("n", "[l", ":lprev<CR>", { desc = "Previous location list item" })
keymap("n", "]L", ":llast<CR>", { desc = "Last location list item" })
keymap("n", "[L", ":lfirst<CR>", { desc = "First location list item" })

return {}
