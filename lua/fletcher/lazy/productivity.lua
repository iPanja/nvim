return {
    -- Session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup({
                dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
                options = { "buffers", "curdir", "tabpages", "minsize" },
            })

            vim.keymap.set("n", "<leader>sl", function()
                require("persistence").load()
            end, { desc = "Restore last session" })

            vim.keymap.set("n", "<leader>ss", function()
                require("persistence").select()
            end, { desc = "Select session" })

            vim.keymap.set("n", "<leader>sd", function()
                require("persistence").stop()
            end, { desc = "Stop persistence" })
        end,
    },

    -- Testing framework
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Language adapters
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-jest",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-go"),
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "pytest",
                    }),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        jestConfigFile = "jest.config.js",
                        env = { CI = true },
                        cwd = function()
                            return vim.fn.getcwd()
                        end,
                    }),
                },
            })

            local keymap = vim.keymap.set
            keymap("n", "<leader>tt", function()
                require("neotest").run.run()
            end, { desc = "Run nearest test" })

            keymap("n", "<leader>tF", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, { desc = "Run file tests" })

            keymap("n", "<leader>ta", function()
                require("neotest").run.run(vim.fn.expand("%"))
            end, { desc = "Stop running tests" })

            keymap("n", "<leader>ts", function()
                require("neotest").summary.toggle()
            end, { desc = "Toggle test summary" })

            keymap("n", "<leader>to", function()
                require("neotest").output.open({ enter = true, auto_close = true }) 
            end, { desc = "Show test output" })

            keymap("n", "<leader>tO", function()
                require("neotest").output_panel.toggle()
            end, { desc = "Toggle test output panel" })

            keymap("n", "<leader>tS", function()
                require("neotest").run.stop()
            end, { desc = "Stop running tests" })
        end,
    },

    -- Color highlighting
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
                enable_named_colors = true,
                enable_tailwind = true,
            })
        end,
    },

    -- TODO comments highlighting
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup({
                signs = true,
                sign_priority = 8,
                keywords = {
                    FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning" },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", color = "info", alt = { "OPTIM", "OPTIMIZE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
                merged_keywords = true,
                highlight = {
                    multiline = true,
                    multiline_pattern = "^.",
                    multiline_context = 10,
                    before = "",
                    keyword = "wide",
                    after = "fg",
                    pattern = [[.*<(KEYWORDS)\s*:]],
                    comments_only = true,
                    max_line_len = 400,
                    exclude = {},
                },
                colors = {
                    error = { "DiagnosticError", "ErrorMsg", "#DC2626"},
                    warning = { "DiagnosticWarning", "WarningMsg", "#FBBF20" },
                    info = { "DiagnosticInfo", "#2563EB" },
                    hint = { "DiagnosticHint", "#10B981" },
                    default = { "Identifier", "#7C3AED" },
                    test = { "Identifier", "#FF00FF" },
                },
                search = {
                    command = "rg",
                    args = {
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                    },
                    pattern = [[\b(KEYWORDS):]],
                },
            })

            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find TODOs" })
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next TODO" })    
            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous TODO" })
        end,
    },
}