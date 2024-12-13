-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map({ "n", "v" }, "<leader>gf", function()
  require("telescope.builtin").find_files({ find_command = { "fd", vim.fn.expand("<cword>") } })
end, { desc = "Find file under cursor" })
map({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader><space>", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
map({ "n", "v" }, "<leader>/", LazyVim.pick("live_grep", { root = false }), { desc = "Grep (cwd)" })
