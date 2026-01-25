return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    specs = {
      {
        {
          "akinsho/bufferline.nvim",
          optional = true,
          opts = function(_, opts)
            if (vim.g.colors_name or ""):find("catppuccin") then
              opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
            end
          end,
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/lub/library", words = { "vim%.uv" } },
      },
    },
    config = function()
      local lazydev = require("lazydev")
      lazydev.setup({
        library = { "nvim-dap-ui" },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },
  { -- optional blink completion source for require statements and module annotations
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  { "nvim-tree/nvim-web-devicons" },
}
