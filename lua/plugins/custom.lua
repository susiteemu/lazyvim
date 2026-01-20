-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown", "telekasten" },
      })
    end,
  },
  { "ziglang/zig.vim" },

  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    opts = function(_, opts)
      -- Ensure tables exist
      opts.servers = opts.servers or {}
      opts.setup = opts.setup or {}

      -- Define all your servers
      opts.servers.gopls = opts.servers.gopls or {}
      opts.servers.pyright = opts.servers.pyright or {}
      opts.servers.ansiblels = opts.servers.ansiblels or {}
      opts.servers.arduino_language_server = opts.servers.arduino_language_server or {}
      opts.servers.volar = opts.servers.volar or { settings = {} }
      opts.servers.ruff = opts.servers.ruff or {}
      opts.servers.groovyls = opts.servers.groovyls or { mason = false }
      opts.servers.rust_analyzer = opts.servers.rust_analyzer or {}
      local util = require("lspconfig.util")

      local esp_clangd = vim.fn.expand("$HOME/.espressif/tools/esp-clang/esp-clang/bin/clangd")
      local ncs_clangd = vim.fn.exepath("clangd")
      local default_clangd = "clangd"

      -- Detection functions
      local function is_espidf(root)
        return vim.fn.filereadable(root .. "/sdkconfig") == 1
      end

      local function is_zephyr(root)
        local zephyr_dir = root .. "/build/zephyr"
        return vim.fn.isdirectory(zephyr_dir) == 1
      end

      -- Dynamic cmd chooser
      local function choose_clangd_cmd(root_dir)
        if is_espidf(root_dir) then
          return {
            esp_clangd,
            "--compile-commands-dir=build",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
        elseif is_zephyr(root_dir) then
          return {
            ncs_clangd,
            "--compile-commands-dir=build",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
        else
          return { default_clangd, "--background-index" }
        end
      end

      -- Root dir detection (compile_commands.json or sdkconfig or git)
      local function detect_root(fname)
        return util.root_pattern("compile_commands.json", "sdkconfig", ".git")(fname) or vim.fn.getcwd()
      end

      opts.servers.clangd = {
        cmd = choose_clangd_cmd(vim.fn.getcwd()),
        root_dir = detect_root,
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      }
      -- Setup overrides
      opts.setup.groovyls = function(_, _)
        require("lspconfig").groovyls.setup({
          cmd = { "java", "-jar", vim.env.HOME .. "/bin/groovy-language-server-all.jar" },
        })
        return true
      end

      opts.setup.pyright = function()
        require("lspconfig").pyright.setup({
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                ignore = { "*" },
              },
            },
          },
        })
      end

      return opts
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "go",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "zig",
      })
    end,
  },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = vim.g.border_type,
      },
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "ruff",
        "ansible-lint",
      },
    },
  },

  { "HiPhish/rainbow-delimiters.nvim" },
  { "aklt/plantuml-syntax" },
  { "dhruvasagar/vim-table-mode" },
  {
    "stevearc/conform.nvim",
    -- Everything in opts will be passed to setup()
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        arduino = { "clang_format" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cs = { "clang_format" },
        css = { "prettier" },
        cuda = { "clang_format" },
        go = { "gofmt", "goimports" },
        graphql = { "prettier" },
        groovy = { "npm_groovy_lint" },
        handlebars = { "prettier" },
        html = { "prettier" },
        htmldjango = { "prettier" },
        java = { "google_java_format" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        less = { "prettier" },
        lua = { "stylua" },
        proto = { "clang_format" },
        python = { "ruff_fix", "ruff_format" },
        -- rust = { "rustfmt" },
        scss = { "prettier" },
        svelte = { "prettier" },
        toml = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        xml = { "xmllint" },
        yaml = { "prettier" },
      },
      -- Customize formatters
      formatters = {
        prettier = {
          command = "/usr/local/bin/prettier",
          prepend_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        },
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        npm_groovy_lint = {
          command = "/usr/local/bin/npm-groovy-lint",
          prepend_args = { "--format" },
        },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        html = { "tidy" },
      },
    },
  },

  { "mzlogin/vim-markdown-toc" },

  { "tpope/vim-sleuth" },

  { "khaveesh/vim-fish-syntax" },

  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip").filetype_extend("svelte", { "javascript" })
      require("luasnip").filetype_extend("typescript", { "javascript" })
    end,
  },

  { "leafOfTree/vim-svelte-plugin" },

  {
    "folke/which-key.nvim",
    opts = { preset = "modern" },
  },

  { "lewis6991/spaceless.nvim" },

  { "dkarter/bullets.vim" },

  { "pearofducks/ansible-vim" },

  { "mfussenegger/nvim-jdtls" },

  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup({
        filetypes = {
          "astro",
          "djangohtml",
          "glimmer",
          "handlebars",
          "hbs",
          "html",
          "javascript",
          "javascriptreact",
          "jsx",
          "markdown",
          "php",
          "rescript",
          "svelte",
          "tsx",
          "typescript",
          "typescriptreact",
          "vue",
          "xml",
        },
      })
    end,
  },

  {
    "johmsalas/text-case.nvim",
    config = function()
      require("textcase").setup({})
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({})
    end,
  },

  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
    config = function()
      require("multicursors").setup({
        hint_config = {
          float_opts = {
            border = "rounded",
          },
          position = "bottom-right",
        },
        generate_hints = {
          normal = true,
          insert = true,
          extend = true,
          config = {
            column_count = 1,
            max_hint_length = 50,
          },
        },
      })
    end,
  },

  {
    "stevearc/oil.nvim",
    config = function()
      local detail = false
      require("oil").setup({
        win_options = { winbar = "%!v:lua.get_oil_winbar()" },
        view_options = { show_hidden = true },
        keymaps = {
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
      })
    end,
    opts = {},
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      oldfiles = {
        prompt = "❯ ",
        cwd_only = true,
        stat_file = true, -- verify files exist on disk
        -- can also be a lua function, for example:
        -- stat_file = require("fzf-lua").utils.file_is_readable,
        -- stat_file = function() return true end,
        include_current_session = true, -- include bufs from current session
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "￨", right = "￨" },
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
    opts = { border = "rounded", width_ratio = 0.95, height_ratio = 0.95 },
  },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
