local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu)

vim.keymap.set("n", "<leader>n1", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>n2", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>n3", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>n4", function() ui.nav_file(4) end)
vim.keymap.set("n", "<leader>n5", function() ui.nav_file(5) end)
vim.keymap.set("n", "<leader>n6", function() ui.nav_file(6) end)
vim.keymap.set("n", "<leader>n7", function() ui.nav_file(7) end)
vim.keymap.set("n", "<leader>n8", function() ui.nav_file(8) end)
vim.keymap.set("n", "<leader>n9", function() ui.nav_file(9) end)
vim.keymap.set("n", "<leader>n0", function() ui.nav_file(10) end)

