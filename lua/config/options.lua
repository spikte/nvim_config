local options = {
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
    cmdheight = 1,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    fileencoding = "utf-8",                  -- the encoding written to a file
    hlsearch = true,                         -- highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    mouse = "a",                             -- allow the mouse to be used in neovim
    pumheight = 10,                          -- pop up menu height
    showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2,                         -- always show tabs
    smartcase = true,                        -- smart case
    smartindent = true,                      -- make indenting smarter again
    swapfile = false,                        -- creates a swapfile
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 300,                        -- faster completion (4000ms default)
    writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    expandtab = true,                        -- convert tabs to spaces
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    tabstop = 4,                             -- insert 2 spaces for a tab
    cursorline = true,                       -- highlight the current line
    number = true,                           -- set numbered lines
    relativenumber = false,                  -- set relative numbered lines
    numberwidth = 4,                         -- set number column width to 2 {default 4}
    relativenumber = true,                   -- show the line number relative to the line with the cursor
    foldmethod = "indent",                   -- fold based on indent

    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    wrap = false,                            -- display lines as one long line
    scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- Display LSP diagnostics
vim.cmd [[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
]]

-- Vim slime config
vim.g.slime_target = "neovim"

-- Remove `~` char in the margin
vim.opt.fillchars = {eob = " "}

vim.api.nvim_set_hl(0, "ExtraWhitespace", {
    ctermbg = "red",
    bg = "red",
})

--vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
vim.cmd("packadd cfilter")

--Disable folding in dap-view
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-view",
  callback = function()
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.foldenable = false
  end,
})
