-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Do not conceal anything
vim.opt.conceallevel = 0

-- catppuccin
vim.g.catppuccin_flavour = "mocha"

-- lervag/wiki
vim.g.wiki_root = "~/wiki"
vim.g.wiki_filetypes = { "md" }
vim.g.wiki_link_extension = ".md"
vim.g.wiki_export = {
  args = '-s -H $HOME/wiki/export.css -V "mainfont:Helvetica,sans-serif"',
  from_format = "markdown",
  ext = "html",
  link_ext_replace = false,
  view = true,
  output = "export",
}

-- pearofducks/ansible-vim
vim.g.ansible_unindent_after_newline = true

-- dkarter/bullets.vim
vim.g.bullets_delete_last_bullet_if_empty = true

-- misc
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<,nbsp:+"
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 0
vim.opt.tabstop = 4
vim.opt.wildignorecase = true
vim.opt.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
]]
vim.opt.wrap = true
