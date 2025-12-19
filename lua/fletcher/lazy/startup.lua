return {
  -- Project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        -- Detection methods to use
        detection_methods = { "pattern", "lsp" },
        
        -- Patterns to detect project root
        patterns = { 
          ".git", 
          "_darcs", 
          ".hg", 
          ".bzr", 
          ".svn", 
          "Makefile", 
          "package.json",
          "go.mod",
          "Cargo.toml",
          "pyproject.toml",
          "requirements.txt"
        },
        
        -- Don't show hidden files in telescope
        show_hidden = false,
        
        -- When set to false, won't automatically change root directory
        silent_chdir = true,
        
        -- Path to store project history
        datapath = vim.fn.stdpath("data"),
      })
      
      -- Integrate with telescope if available
      pcall(function()
        require("telescope").load_extension("projects")
      end)
    end,
  },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "",
            "",
            "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            "",
            "",
          },
          center = {
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find File                           ",
              desc_hl = "String",
              key = "f",
              key_hl = "Number",
              action = "Telescope find_files",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Recent Files                        ",
              desc_hl = "String",
              key = "r",
              key_hl = "Number",
              action = "Telescope oldfiles",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find Text                           ",
              desc_hl = "String",
              key = "g",
              key_hl = "Number",
              action = "Telescope live_grep",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Projects                            ",
              desc_hl = "String",
              key = "p",
              key_hl = "Number",
              action = "Telescope projects",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Restore Session                     ",
              desc_hl = "String",
              key = "s",
              key_hl = "Number",
              action = "lua require('persistence').load()",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Config                              ",
              desc_hl = "String",
              key = "c",
              key_hl = "Number",
              action = "edit ~/.config/nvim/init.lua",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Lazy                                ",
              desc_hl = "String",
              key = "l",
              key_hl = "Number",
              action = "Lazy",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Quit                                ",
              desc_hl = "String",
              key = "q",
              key_hl = "Number",
              action = "quit",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "",
              "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
            }
          end,
        },
      })
    end,
  },
}