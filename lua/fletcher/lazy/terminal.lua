return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- Size can be a number or function
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
        winblend = 0,
      },
      
      winbar = {
        enabled = false,
      },
    })

    -- Terminal mode mappings for easier navigation
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      -- Exit terminal mode with ESC
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      -- Window navigation from terminal
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      -- Close terminal window
      vim.keymap.set("t", "<C-q>", [[<C-\><C-n>:q<CR>]], opts)
    end

    -- Apply terminal keymaps when terminal opens
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    -- Custom terminal functions
    local Terminal = require("toggleterm.terminal").Terminal

    -- Floating terminal
    local float_term = Terminal:new({
      direction = "float",
      hidden = true,
    })

    function _FLOAT_TOGGLE()
      float_term:toggle()
    end

    -- Horizontal terminal
    local horizontal_term = Terminal:new({
      direction = "horizontal",
      hidden = true,
    })

    function _HORIZONTAL_TOGGLE()
      horizontal_term:toggle()
    end

    -- Vertical terminal
    local vertical_term = Terminal:new({
      direction = "vertical",
      hidden = true,
    })

    function _VERTICAL_TOGGLE()
      vertical_term:toggle()
    end

    -- Keybindings
    vim.keymap.set("n", "<leader>tf", "<cmd>lua _FLOAT_TOGGLE()<CR>", { desc = "Toggle floating terminal" })
    vim.keymap.set("n", "<leader>th", "<cmd>lua _HORIZONTAL_TOGGLE()<CR>", { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>tv", "<cmd>lua _VERTICAL_TOGGLE()<CR>", { desc = "Toggle vertical terminal" })
    
    -- Additional useful keybindings
    vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "Toggle lazygit" })
    vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Toggle node REPL" })
    vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Toggle python REPL" })

    -- Lazygit integration
    local lazygit = Terminal:new({
      cmd = "lazygit",
      direction = "float",
      hidden = true,
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.95)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.95)
        end,
      },
    })

    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    -- Node REPL
    local node = Terminal:new({
      cmd = "node",
      direction = "float",
      hidden = true,
    })

    function _NODE_TOGGLE()
      node:toggle()
    end

    -- Python REPL
    local python = Terminal:new({
      cmd = "python3",
      direction = "float",
      hidden = true,
    })

    function _PYTHON_TOGGLE()
      python:toggle()
    end
  end,
}