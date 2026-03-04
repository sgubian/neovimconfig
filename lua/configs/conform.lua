local conform = require("conform")

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    r = { "air", line_width = 120 },
    css = { "prettier" },
    html = { "prettier" },
    rust = { "rustfmt" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

vim.keymap.set("n", "<leader>cf", function()
  conform.format { async = true }
end, { desc = "Format file" })


return options
