return {
    -- Session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup({
                dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
                options = { "buffers", "curdir", "tabpages", "winsize" },
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
                require("neotest").run.run(vim.fn.getcwd())
            end, { desc = "Run all tests" })

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

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown" },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
            vim.g.mkdp_refresh_slow = 0
            vim.g.mkdp_command_for_global = 0
            vim.g.mkdp_open_to_the_world = 0
            vim.g.mkdp_browser = ""
            vim.g.mkdp_echo_preview_url = 0
            -- vim.g.mkdp_open_to_the_vim_width_cmd = 0
            -- vim.g.mkdp_theme = "light"
            vim.g.mkdp_preview_options = {
                mkit = {},
                katex = {},
                uml = {},
                mermaid = {},
                maid = {},
                disable_sync_scroll = 0,
                sync_scroll_type = "middle",
                hide_yaml_meta = 1,
                sequence_diagrams = {},
                flowchart_diagrams = {},
                content_editable = false,
            }

            vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Toggle markdown preview" })
        end,
    },

    -- Color highlighting
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
                enable_named_colors = true,
                enable_tailwind = false,
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
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
                    TEST = { icon = " ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
                },
                merge_keywords = true,
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
                    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
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

            vim.keymap.set("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "Find todos" })
            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo" })
            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo" })
        end,
    },
}