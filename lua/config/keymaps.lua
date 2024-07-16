-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader>fc", "<cmd>let @+ = expand('%:p')<cr>", {
  desc = "Yank current buffer's absolute path",
})
map({ "n", "v" }, "<leader>gf", function()
  require("telescope.builtin").find_files({ find_command = { "fd", vim.fn.expand("<cword>") } })
end, { desc = "Find file under cursor" })
map({ "n", "v" }, "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Text case conversions" })
map({ "n", "v" }, "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader>jf", function()
  require("jenkinsfile_linter").validate()
end, { desc = "Validate a Jenkinsfile" })
map({ "n", "v" }, "'", '"0')
map({ "n", "v" }, "<leader><space>", LazyVim.pick("files", { root = false }), { desc = "Find Files (cwd)" })
map({ "n", "v" }, "<leader>/", LazyVim.pick("live_grep", { root = false }), { desc = "Grep (cwd)" })

-- Launch panel if nothing is typed after <leader>z
map({ "n" }, "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
map({ "n" }, "<leader>zf", "<cmd>Telekasten find_notes<CR>")
map({ "n" }, "<leader>zg", "<cmd>Telekasten search_notes<CR>")
map({ "n" }, "<leader>zd", "<cmd>Telekasten goto_today<CR>")
map({ "n" }, "<leader>zz", "<cmd>Telekasten follow_link<CR>")
map({ "n" }, "<leader>zn", "<cmd>Telekasten new_note<CR>")
map({ "n" }, "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
map({ "n" }, "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
map({ "n" }, "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
map({ "i" }, "[[", "<cmd>Telekasten insert_link<CR>")
