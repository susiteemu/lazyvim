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
