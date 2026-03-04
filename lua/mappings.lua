require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>e", "<cmd>lua require('snacks.explorer').open()<CR>", { desc = "Snacks Explorer" })-- add yours here
pcall(vim.keymap.del, "n", "<C-n>")

-- Map Ctrl+n to Snacks explorer
map("n", "<C-n>", function()
  require("snacks.explorer").open()
end, { desc = "Snacks Explorer" })


map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
