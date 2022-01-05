vim.api.nvim_set_keymap("n", "<space>", '<cmd>let @/ = ""<Cr>', { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "kj", '<escape>', { noremap = true, silent = true })
