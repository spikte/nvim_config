local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        {
            'vague-theme/vague.nvim',
            priority = 1000,
            init = function() vim.cmd("colorscheme vague") end
            -- optionally set the colorscheme within lazy config
        },
        -- TreeSitter for highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            config = function ()
                local configs = require("nvim-treesitter.configs")

                configs.setup({
                    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "html", "python" },
                    sync_install = false,
                    highlight = { enable = true },
                    indent = { enable = false },
                })
            end
        },
        -- Indent line
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {}
        },
        -- Buffer tab
        {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            opts = {}
        },
        -- Manipulation of parenthesis
        { "tpope/vim-surround", config = function() end },
        -- Commenting code
        { "tpope/vim-commentary", config = function() end },
        -- Autoclosing of (, {, [, etc
        { "m4xshen/autoclose.nvim", opts = {} },
        -- init.lua:
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            -- or                              , branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        -- Highlight colors
        {
            'brenoprata10/nvim-highlight-colors',
            config = function()
                local configs = require('nvim-highlight-colors')
                configs.setup({})
            end
        },
        { 'jpalardy/vim-slime', config = function() end },
        -- VimTex
        {
            "lervag/vimtex",
            lazy = false,     -- we don't want to lazy load VimTeX
            init = function()
                -- VimTeX configuration goes here, e.g.
                vim.g.vimtex_view_method = "zathura"
            end
        },
        --
        {
            'stevearc/overseer.nvim',
            ---@module 'overseer'
            ---@type overseer.SetupOpts
            opts = {},
        },
        -- DAP
        {
            'mfussenegger/nvim-dap',
            config = function()
                local dap = require('dap')
                dap.adapters.lldb = {
                    type = "server",
                    port = 13000,
                    executable = {
                        command = "lldb-dap",
                        args = { "--connection", "listen://localhost:13000" }
                    }
                }
            end
        },
        {
            "igorlfs/nvim-dap-view",
            ---@module 'dap-view'
            ---@type dapview.Config
            opts = {},
        },
        {
            'Maduki-tech/nvim-plantuml',
            config = function()
                require('plantuml').setup({
                    output_dir = '/tmp',
                    viewer = 'open',
                    auto_refresh = true,
                })
            end
        },
        {
            'folke/zen-mode.nvim',
        }
    },
})
