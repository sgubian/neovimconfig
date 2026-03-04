return {
   {
    "nvim-tree/nvim-tree.lua",
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    opts = {},
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup {
        completion = {
          cmp = {
            enabled = true,
          },
        },
      }
      require("cmp").setup.buffer {
        sources = { { name = "crates" } },
      }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    },
  },
  -- {
  --   "R-nvim/R.nvim",
  --   -- Only required if you also set defaults.lazy = true
  --   lazy = false,
  --   config = function()
  --     -- Create a table with the options to be passed to setup()
  --     local opts = {
  --       hook = {
  --         on_filetype = function()
  --           vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
  --           vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
  --         end,
  --       },
  --       R_args = { "--quiet", "--no-save" },
  --       min_editor_width = 72,
  --       rconsole_width = 78,
  --       objbr_mappings = { -- Object browser keymap
  --         c = "class", -- Call R functions
  --         ["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
  --         v = function()
  --           -- Run lua functions
  --           require("r.browser").toggle_view()
  --         end,
  --       },
  --       -- disable_cmds = {
  --       --   "RClearConsole",
  --       --   "RCustomStart",
  --       --   "RSPlot",
  --       --   "RSaveClose",
  --       -- },
  --     }
  --     require("r").setup(opts)
  --   end,
  -- },
  {
    "Vigemus/iron.nvim",
    lazy = false,
    config = function()
      local iron = require "iron.core"
      local common = require "iron.fts.common"
      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
            json = { "jq" },
            python = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
              env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13
            },
            R = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "radian" },
              -- block_dividers = {
              --   open = "{",
              --   close = "}",
              -- },
            },
            r = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "radian" },
              format = require("iron.fts.common").bracketed_paste,
              -- block_dividers = {
              --   open = "{",
              --   close = "}",
              -- },
            },
            quarto = {
              command = { "radian" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require("iron.view").split "40%",
        },
        -- iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          toggle_repl = "<space>rr", -- toggles the repl open and closed.
          -- If repl_open_command is a table as above, then the following keymaps are
          -- available
          -- toggle_repl_with_cmd_1 = "<space>rv",
          -- toggle_repl_with_cmd_2 = "<space>rh",
          restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_paragraph = "<space>sp",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          send_code_block = "<space>sb",
          send_code_block_and_move = "<space>sn",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      vim.keymap.set("n", "<localleader>rS", "<cmd>IronRepl<cr>", { desc = "[R]EPL [S]tart" })
      vim.keymap.set("n", "<localleader>rR", "<cmd>IronRestart<cr>", { desc = "[R]EPL [R]estart" })
      vim.keymap.set("n", "<localleader>rF", "<cmd>IronFocus<cr>", { desc = "[R]EPL [F]ocus" })
      vim.keymap.set("n", "<localleader>rH", "<cmd>IronHide<cr>", { desc = "[R]EPL [H]ide" })
      vim.keymap.set("n", "<space>sb", function()
        local start_line = vim.fn.line "."
        vim.fn.search("{", "c")
        vim.cmd "normal! %"
        local end_line = vim.fn.line "."

        local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, true)
        local code = table.concat(lines, "\r")

        -- Manually wrap in bracketed paste codes
        local wrapped = "\x1b[200~" .. code .. "\x1b[201~\r"
        require("iron.core").send(nil, wrapped)
      end, { desc = "Send R function" })
      -- vim.keymap.set("n", "<space>sb", function()
      --   local start_line = vim.fn.line "."
      --   vim.fn.search("{", "c")
      --   vim.cmd "normal! %"
      --   local end_line = vim.fn.line "."
      --
      --   -- Get all lines from start to end (inclusive)
      --   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      --   local code = table.concat(lines, "\n") .. "\n"
      --
      --   require("iron.core").send(nil, code)
      -- end, { desc = "Send R function" })
      -- Send entire R function
    end,
  },
  {
    "gennaro-tedesco/nvim-jqx",
    event = { "BufReadPost" },
    ft = { "json", "yaml" },
    keys = {
      { "<leader>jx", "<cmd>JqxList<cr>", desc = "Open jqx" },
      { "<leader>jq", "<cmd>JqxQuery<cr>", desc = "Run jq query" },
    },
  },
  {
    "David-Kunz/gen.nvim",
    lazy = false,
    config = function()
      require "configs.gen"
    end,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<C-n>", function() require("snacks").explorer.toggle() end, desc = "Toggle Explorer" },
      { "<leader>e", function() require("snacks").explorer.toggle() end, desc = "Toggle Explorer" },
    },
  },
  {
    "stevearc/aerial.nvim",
    lazy = false,
  },
}
