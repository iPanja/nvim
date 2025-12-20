return {
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            labels = "asdfghjklqwertyiopzxcvbnm",
            search = {
                multi_window = true,
                forward = true,
                wrap = true,
                mode = "exact",
            },
            jump = {
                jumplist = true,
                pos = "start",
                history = false,
                register = false,
                nohlsearch = false,
                autojump = false,
            },
            label = {
                uppercase = true,
                rainbow = {
                    enabled = false,
                    shade = 5,
                },
            },
            modes = {
                search = {
                    enabled = true,
                },
                char = {
                    enabled = true,
                    keys = { "f", "F", "t", "T", ";", "," },
                    jump_labels = true,
                    autohide = false,
                    jump = {
                        autojump = false,
                    },
                },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash jump",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Flash remote",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Flash treesitter search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Flash toggle search",
            },
        },
    },
}