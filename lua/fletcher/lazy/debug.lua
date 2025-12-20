return {
    -- Debug Adapter Protocol
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            local keymap = vim.keymap.set
            -- Setup DAP UI
            dapui.setup({
                icons = { expanded = "", collapsed = "", current_collapsed = "", current_frame = "" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = nil, -- These can be integers or a float between 0 and 1.
                    max_width = nil, -- Floats will be treated as percentage of your screen size.
                    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- Setup DAP Virtual Text
            require("nvim-dap-virtual-text").setup({
                enabled = true,
                enabled_commands = true,
                highlight_changed_variables = true,
                highlight_new_as_changed = false,
                show_stop_reason = true,
                commented = false,
                only_first_definition = true,
                all_references = false,
                filter_references_pattern = "<module",
                virt_text_pos = "eol",
                all_frames = false,
                virt_lines = false,
                virt_text_win_col = nil,
            })

            -- Auto open/close DAP UI
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            keymap("n", "<F5>", function() dap.continue() end, { desc = "Debug: continue" })
            keymap("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step over" })
            keymap("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step into" })
            keymap("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step out" })
            keymap("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle breakpoint" })
            keymap("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Debug: Conditional breakpoint" })
            keymap("n", "<leader>dr", function() dap.repl.open() end, { desc = "Debug: Open REPL" })
            keymap("n", "<leader>dl", function() dap.run_last() end, { desc = "Debug: Run last" })
            keymap("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle UI" })
            keymap("n", "<leader>dt", function() dapui.terminate() end, { desc = "Debug: Terminate" })

        end,
    },

    -- Go debugging
    {
        "leoluz/nvim-dap-go",
        ft = "go",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require("dap-go").setup({
                dap_configurations = {
                    {
                        type = "go",
                        name = "Attach remote",
                        mode = "remote",
                        request = "attach",
                    },
                },
                delve = {
                    path = "dlv",
                    initialize_timeout_sec = 20,
                    port = "${port}",
                    args = {},
                    build_flags = "",
                },
            })
        end,
    },

    -- Python debugging
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            -- Try to find python3 with debugpy installed
            local python3_path = vim.fn.exepath("python3")
            require("dap-python").setup(python3_path)
        end,
    },

    -- Javascript/Typescript debugging
    {
        "mxsdev/nvim-dap-vscode-js",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        dependencies = {
            "mfussenegger/nvim-dap",
            {
                "microsoft/vscode-js-debug",
                build = function()
                    local install_cmd = [[
                        export NVM_DIR="$HOME/.nvm"
                        NVM_BREW_PREFIX="/opt/homebrew/opt/nvm"
                        [ -s "$NVM_BREW_PREFIX/nvm.sh" ] && source "$NVM_BREW_PREFIX/nvm.sh"
                        npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out
                    ]]
                    vim.fn.system(install_cmd)
                end,
            },
        },
        config = function()
            require("dap-vscode-js").setup({
                debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
            })

            local dap = require("dap")

            for _, language in ipairs({ "javascript", "typescript", "typescriptreact", "javascriptreact" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-chrome",
                        request = "launch",
                        name = "Launch Chrome",
                        url = "http://localhost:3000",
                        webRoot = "${workspaceFolder}",
                    },
                }
            end
        end,
    },

    -- C/C++ Debugging
    {
        "jay-babu/mason-nvim-dap.nvim",
        ft = { "c", "cpp" },
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "codelldb" },
                handlers = {},
            })

            local dap = require("dap")

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
                {
                    name = "Attach to process",
                    type = "codelldb",
                    request = "attach",
                    -- program = function()
                        -- return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    -- end,
                    pid = require("dap.utils").pick_process,
                    args = {},
                },
            }

            -- C uses the same configurations as C++
            dap.configurations.c = dap.configurations.cpp
        end,
    }
}