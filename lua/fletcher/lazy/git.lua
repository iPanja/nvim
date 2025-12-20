return {
    -- Inline git status indicators
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆┆" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 1000,
                    ignore_whitespace = false,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "rounded",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation between hunks
                    map("n", "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Next hunk" })

                    map("n", "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Previous hunk" })

                    -- Actions
                    map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })

                    map("v", "<leader>hs", function()
                        gs.stage_hunk({vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Stage hunk" })
                    map("v", "<leader>hr", function()
                        gs.reset_hunk({vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Reset hunk" })

                    map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
                    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>gb", function()
                        gs.blame_line({ full = true })
                    end, { desc = "Git blame line" })
                    map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
                    map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
                    map("n", "<leader>hD", function()
                        gs.diffthis("~")
                    end, { desc = "Diff this (~) with base" })
                    map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle deleted" })
                    
                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
                end,
            })
        end,
    },

    -- Git commands
    {
        "tpope/vim-fugitive",
        dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                use_icons = true,
            })
            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git status" })
            vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
            vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
            vim.keymap.set("n", "<leader>gp", ":Git pull<CR>", { desc = "Git pull" })

            vim.keymap.set("n", "<leader>gm", ":Gvdiffsplit!<CR>", { desc = "Git 3-way merge conflict view" })
            vim.keymap.set("n", "<leader>gl", ":diffget //12<CR>", { desc = "Accept left (ours)" })
            vim.keymap.set("n", "<leader>gr", ":diffget //3<CR>", { desc = "Accept right (theirs)" })
            
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "File history" })
            vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Branch history" })
            vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Close diff view" })
            -- vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
        end,
    },

    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                use_icons = true,
            })

            vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Open diff view" })
            vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "File history" })
            vim.keymap.set("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Branch history" })
            vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", { desc = "Close diff view" })
            vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
        end,
    },
}