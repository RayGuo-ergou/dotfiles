-- set leader key to space
vim.g.mapleader = " "

-- key mapping
local keymap = vim.keymap -- for conciseness

-- Operator Pending Mode Keybindings
keymap.set("o", "L", "$", { noremap = true, silent = true })
keymap.set("o", "H", "^", { noremap = true, silent = true })

-- Normal Mode Keybindings Non Recursive
keymap.set("n", "<C-n>", ":nohl<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>c", "caw", { noremap = true, silent = true })
keymap.set("n", "<leader>h", "^", { noremap = true, silent = true })
keymap.set("n", "<leader>l", "$", { noremap = true, silent = true })
keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
keymap.set("n", "1", "*", { noremap = true, silent = true })
keymap.set("n", "2", "#", { noremap = true, silent = true })

-- Visual Mode Keybindings
keymap.set("v", "<leader>", "<esc>", { noremap = true, silent = true })
keymap.set("v", "L", "$", { noremap = true, silent = true })
keymap.set("v", "H", "^", { noremap = true, silent = true })

-- Insert Mode Keybindings
keymap.set("i", "jj", "<esc>", { noremap = true, silent = true })
keymap.set("i", "<C-n>", "<esc>:nohl<CR>", { noremap = true, silent = true })

-- save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
