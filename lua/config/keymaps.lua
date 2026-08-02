local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

-- Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Split
keymap("n", "<leader>sh", ":set nospr <bar> vsplit <CR>", opts)
keymap("n", "<leader>sj", ":set sb <bar> split <CR>", opts)
keymap("n", "<leader>sk", ":set nosb <bar> split <CR>", opts)
keymap("n", "<leader>sl", ":set spr <bar> vsplit <CR>", opts)
-- Split navigation
keymap("n", "<leader>wh", "<C-w>h", opts)
keymap("n", "<leader>wj", "<C-w>j", opts)
keymap("n", "<leader>wk", "<C-w>k", opts)
keymap("n", "<leader>wl", "<C-w>l", opts)
-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
-- "Reset highlight
keymap("n",  "<Leader><Leader>", ":noh<CR>", opts)
-- "Go to definition
keymap("n", "gd", "<C-]>", opts)
-- Scroll
keymap("n", "<leader>k", "<C-e>")
keymap("n", "<leader>j", "<C-y>")
-- Delete trailing whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})


-- Visual --
--Align tabular data
keymap("v", "<leader><tab>", ":'<,'>!column -t <CR>", opts)


-- Visual Block --


-- Terminal mode --
keymap("t", ",<Esc>", "<C-\\><C-N>", opts)


-- Run --
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python', 'py' },
    callback = function(args)
        keymap("n", "<Leader>r", ":split | terminal python % <CR>")
    end
})

-- Telescope --
local telescope = require('telescope.builtin')
keymap('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
keymap('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
keymap('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
keymap('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })
keymap('n', '<leader>fm',
       function()
           telescope.man_pages({sections = { "ALL" }})
       end,
       { desc = 'Telescope man pages' })

-- DAP --
local dap = require('dap')
local dap_view = require('dap-view')
keymap('n', '<leader>b', function() dap.toggle_breakpoint() end)
keymap('n', '<Leader>dr', function() dap.repl.open() end)
keymap('n', '<Right>', function() dap.step_over() end)
keymap('n', '<Down>', function() dap.step_into() end)
keymap('n', '<Leader>dd',
    function()
        require('dap').continue()
        require('dap-view').open()
    end)
keymap('n', '<Leader>dc', function() dap.terminate() end)
keymap('n', '<Leader>do', function() dap_view.toggle() end)

-- Other --
-- C/C++
local function alt_file_open()
    local path = vim.fn.expand('%:p')
    local dir = vim.fn.fnamemodify(path, ':h')
    local stem = vim.fn.fnamemodify(path, ':t:r')
    local ext = vim.fn.fnamemodify(path, ':e')

    local ext_map = {
        cpp = 'hpp',
        hpp = 'cpp',
        c   = 'h',
        h   = 'c',
    }

    local alt_ext = ext_map[ext]
    if not alt_ext then
        print("No alternate file found")
        return
    end

    local candidates = {}

    -- 1. Same directory
    table.insert(candidates, dir .. '/' .. stem .. '.' .. alt_ext)

    -- 2. /src/ <-> /include/ swap
    local swapped_path
    if path:match('/src/') then
        swapped_path = path:gsub('/src/', '/include/', 1)
    elseif path:match('/include/') then
        swapped_path = path:gsub('/include/', '/src/', 1)
    end

    if swapped_path then
        local swapped_dir = vim.fn.fnamemodify(swapped_path, ':h')
        table.insert(candidates, swapped_dir .. '/' .. stem .. '.' .. alt_ext)
    end

    for _, candidate in ipairs(candidates) do
        if vim.fn.filereadable(candidate) == 1 then
            vim.cmd('edit ' .. candidate)
            return
        end
    end

    print("File not found: " .. candidates[1])
end

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp' },
    callback = function(args)
        keymap('n', 'vaf', '[{V]}')
        --keymap('n', '<leader>p', ':%!clang-format<CR>')
        keymap('n', '<leader>h', alt_file_open)
    end
})
vim.keymap.set('n', '<leader>p', function()
    vim.lsp.buf.format({
        async = true,
        filter = function(client)
            return client.name == 'clangd'
        end,
    })
end, opts)

