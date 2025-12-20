return {
    -- Trouble.nvim - Pretty diagnostics, references, quickfix list
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            use_diagnostics_signs = true,
            action_keys = { -- key mappings for actions in the trouble list
                close = "q",
                cancel = "<esc>",
                refresh = "r",
                jump = { "<cr>", "<tab>" },
                open_split = { "<c-x>" },
                open_vsplit = { "<c-v>" },
                open_tab = { "<c-t>" },
                jump_close = { "o" },
                toggle_mode = "m",
                toggle_preview = "P",
                help = { "?" },
                hover = "K",
                preview = "p",
                close_folds = { "zM", "zm" },
                open_folds = { "zR", "zr" },
                toggle_fold = { "zA", "za" },
                previous = "k",
                next = "j",
            },
        },
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Trouble: Diagnostics",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Trouble: Buffer diagnostics",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Trouble: Symbols",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "Trouble: LSP definitions / references",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Trouble: Location list",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble quickfix list toggle<cr>",
                desc = "Trouble: Quickfix list",
            },
        },
    },

    -- Dressing.nvim - Better UI for vim.ui.select and vim.ui.input
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                enabled = true,
                default_prompt = "Input:",
                prompt_align = "left",
                insert_only = false,
                start_in_insert = true,
                border = "rounded",
                relative = "editor", -- or "win" or "cursor"
                prefer_width = 40,
                width = nil,
                max_width = { 140, 0.9 },
                min_width = { 20, 0.2 },
                win_options = {
                    winblend = 10,
                    wrap = false,
                },
            },
            select = {
                enabled = true,
                backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
                trim_prompt = true,
                telescope = nil,
                builtin = {
                    border = "rounded",
                    relative = "editor",
                    win_options = {
                        winblend = 10,
                    },
                    width = nil,
                    max_width = { 140, 0.8 },
                    min_width = { 40, 0.2 },
                    height = nil,
                    max_height = 0.9,
                    min_height = { 10, 0.2 },
                },
            },
        },
    },

    -- Nvim-spectre - Search and replace panel
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>sr",
                function()
                    require("spectre").toggle()
                end,
                desc = "Spectre: Toggle",
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual({ select_word = true })
                end,
                desc = "Spectre: Search current word",
            },
            {
                "<leader>sw",
                function()
                    require("spectre").open_visual()
                end,
                desc = "Spectre: Search selected text",
            },
            {
                "<leader>sp",
                function()
                    require("spectre").open_file_search({ select_word = true })
                end,
                desc = "Spectre: Search in current file",
            },
        },
        config = function()
            require("spectre").setup({
                color_devicons = true,
                open_cmd = "vnew",
                live_update = false,
                line_sep_start = "┌---------------------",
                result_padding = "¦  ",
                line_sep = "└---------------------",
                highlight = {
                    ui = "String",
                    search = "DiffChange",
                    replace = "DiffDelete",
                },
                mapping = {
                    ["toggle_line"] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "toggle current item",
                    },
                    ["enter_file"] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>", --enter_file()
                        desc = "goto current file",
                    },
                    ["send_to_qf"] = {
                        map = "<leader>q",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all items to quickfix",
                    },
                    ["replace_cmd"] = {
                        map = "<leader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace command",
                    },
                    ["show_option_menu"] = {
                        map = "<leader>o",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "show options",
                    },
                    ["run_current_replace"] = {
                        map = "<leader>rc",
                        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                        desc = "replace current line",
                    },
                    ["run_replace"] = {
                        map = "<leader>R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all",
                    },
                    ["change_view_mode"] = {
                        map = "<leader>v",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "change result view mode",
                    },
                    ["change_replace_sed"] = {
                        map = "trs",
                        cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
                        desc = "use sed to replace",
                    },
                    ["change_replace_oxi"] = {
                        map = "tro",
                        cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
                        desc = "use oxi to replace",
                    },
                    ["toggle_live_update"] = {
                        map = "tu",
                        cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
                        desc = "update when vim writes to file",
                    },
                    ["toggle_ignore_case"] = {
                        map = "ti",
                        cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
                        desc = "toggle ignore case",
                    },
                    ["toggle_ignore_hidden"] = {
                        map = "th",
                        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                        desc = "toggle search hidden",
                    },
                    ["resume_last_search"] = {
                        map = "<leader>l",
                        cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
                        desc = "resume last search",
                    },
                },
                find_engine = {
                    ["rg"] = {
                        cmd = "rg",
                        args = {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                        },
                        options = {
                            ["ignore-case"] = {
                                value = "--ignore-case",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                            ["hidden"] = {
                                value = "--hidden",
                                icon = "[H]",
                                desc = "hidden file",
                            },
                        },
                    },
                },
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                        args = nil,
                    }
                },
                default = {
                    find = {
                        cmd = "rg",
                        options = { "ignore-case" },
                    },
                    replace = { cmd = "sed" },
                },
            })
        end,
    },
}