return {
  {
    "neovim/nvim-lspconfig",
    ft = { "go", "gomod", "gosum" },
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
          },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local capabilities = cmp_nvim_lsp.default_capabilities()

      if opts.servers and opts.servers.gopls then
        lspconfig.gopls.setup(vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, opts.servers.gopls))
      end
    end,
  },
}

