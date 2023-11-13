-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Operator Pending Mode Keybindings
vim.keymap.set("o", "L", "$", { noremap = true, silent = true })
vim.keymap.set("o", "H", "^", { noremap = true, silent = true })

-- Normal Mode Keybindings Non Recursive
vim.keymap.set("n", "<C-n>", ":nohl<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", "caw", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>h", "^", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>l", "$", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
vim.keymap.set("n", "1", "*", { noremap = true, silent = true })
vim.keymap.set("n", "2", "#", { noremap = true, silent = true })

-- Visual Mode Keybindings
vim.keymap.set("v", "<leader>", "<esc>", { noremap = true, silent = true })
vim.keymap.set("v", "L", "$", { noremap = true, silent = true })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true })

-- Insert Mode Keybindings
vim.keymap.set("i", "jj", "<esc>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<esc>:nohl<CR>", { noremap = true, silent = true })
