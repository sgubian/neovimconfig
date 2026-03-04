vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)


-- require("nvim-tree").setup {
--   diagnostics = {
--     enable = true,
--     show_on_dirs = true,
--     show_on_open_dirs = true,
--     debounce_delay = 50,
--     severity = {
--       min = vim.diagnostic.severity.HINT,
--       max = vim.diagnostic.severity.ERROR,
--     },
--     icons = {
--       hint = "󰌵",
--       info = "󰋼",
--       warning = "󰀦",
--       error = "󰅚",
--     },
--   },
--   update_cwd = true,
--   sync_root_with_cwd = true,
--   renderer = {
--     icons = {
--       git_placement = "before", -- or "after"
--       glyphs = {
--         git = {
--           unstaged = "󰑓",
--           staged = "✓",
--           unmerged = "󰁃",
--           renamed = "➜",
--           untracked = "󰐗",
--           deleted = "󰗨",
--           ignored = "◌",
--         },
--       },
--     },
--   },
-- }
vim.o.winborder = "rounded" -- optional, for all floats

vim.lsp.config("*", {
  handlers = {
    ["textDocument/hover"] = {
      border = "rounded",
      focusable = false,
    },
    ["textDocument/signature_help"] = {
      border = "rounded",
      focusable = false,
    }
  },
})

-- Make ALL LSP floating windows non-focusable
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.focusable = false
  opts.focus = false
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


vim.keymap.set('n', '<Esc>', function()
  -- Close all floating windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { desc = 'Close floating windows' })

vim.keymap.set('n', '<leader>lr', function()
  vim.diagnostic.reset()
  vim.cmd('edit')  -- Reload buffer
end, { desc = 'Refresh LSP diagnostics' })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    local snacks = require("snacks")
    -- Try to get the current explorer instance and refresh it
    if snacks.explorer then
      vim.schedule(function()
        -- Force a redraw/update
        vim.cmd("redraw")
      end)
    end
  end,
})

local lsp = vim.lsp
lsp.config["air"] = {
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        lsp.buf.format()
      end,
    })
  end,
}

vim.lsp.config("r_language_server", {
  cmd = { "R", "--slave", "-e", "languageserver::run()" },
  filetypes = { "r", "rmd" },
  root_markers = { ".git", ".Rproj" },
})
vim.lsp.enable "r_language_server"

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
        ignored = {},
      },
      diagnostics = {
        enable = true,
        experimental = {
          enable = false, -- Disable experimental features that can cause issues
        },
      },
    },
  },
})

vim.lsp.enable "rust_analyzer"

vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.open_float(nil, {
    focus = false,
    border = "rounded",
  })
end)

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code action",
})
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

require("aerial").setup {
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
}
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")

-- Function to show/hide AI
local function toggle_gen_split()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "gen" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  -- If not open, open Gen
  vim.cmd("Gen") -- or whatever command you use
end

-- Alternative
-- vim.keymap.set("n", "<leader>ai", function()
--   local found = false
--
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     if vim.bo[buf].filetype == "gen" then
--       vim.api.nvim_win_close(win, true)
--       found = true
--       break
--     end
--   end
--
--   if not found then
--     vim.cmd("botright vsplit")
--     vim.cmd("buffer gen") -- adjust if needed
--   end
-- end)
--

vim.keymap.set("n", "<leader>ai", toggle_gen_split, { desc = "Toggle Gen AI" })



lsp.enable "air"
-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
