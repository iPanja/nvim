return {
    {
        "sainnhe/everforest",
        priority = 1000, -- Make sure it loads before other plugins
        config = function()
            -- Check for true color support
            -- Enable termguicolors unless using Apple Terminal
            local term_program = vim.env.TERM_PROGRAM or ""
            if not term_program:match("Apple_Terminal") then
                vim.opt.termguicolors = true
            end

            -- Set background (choose either "light" or "dark")
            vim.opt.background = "light"

            -- Set contrast: "hard", "medium" (default), or "soft"
            vim.g.everforest_background = "soft"

            -- Optional: Disable italic comments or other Everforest tweaks here
            -- vim.g.everforest_enable_italic = 0

            -- Load the colorscheme
            vim.cmd.colorscheme("everforest")
        end,
    },
}
