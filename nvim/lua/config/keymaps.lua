-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Operator Pending Mode Keybindings
vim.api.nvim_set_keymap("o", "L", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "H", "^", { noremap = true, silent = true })

-- Normal Mode Keybindings Non Recursive
vim.api.nvim_set_keymap("n", "<C-n>", ":nohl<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>c", "caw", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", "^", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>l", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Visual Mode Keybindings
vim.api.nvim_set_keymap("v", "<leader>", "<esc>", { noremap = true, silent = true })

-- Insert Mode Keybindings
vim.api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-n>", "<esc>:nohl<CR>", { noremap = true, silent = true })
