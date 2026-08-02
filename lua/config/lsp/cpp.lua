-- Launch or attach clangd when opening a C or C++ file
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp' },
    callback = function(args)
        vim.lsp.start({
            name = 'clangd',
            cmd = { 'clangd' },
            root_dir = vim.fs.root(args.buf, { 'Makefile' }),
        })
    end
})
