return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier", "boime" },
        typescript = { "prettier", "biome" },
        javascriptreact = { "prettier", "biome" },
        typescriptreact = { "prettier", "biome" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

		vim.api.nvim_create_user_command("Format", function()
      local formatter = get_closest_formatter({
        biome = { "biome.json" },
        prettier = { ".prettierrc" },
      })

      if not formatter then
        print("formatter not found, using lsp")
        require("conform").format({ async = true, lsp_fallback = true })
      else
        print("formatting with " .. formatter[1])
        require("conform").format({
          async = true,
          formatters = formatter,
          lsp_fallback = false,
        })
      end
    end, {})
    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      local formatter = get_closest_formatter({
        biome = { "biome.json" },
        prettier = { ".prettierrc" },
      })

      if not formatter then
        print("formatter not found, using lsp")
        require("conform").format({ async = true, lsp_fallback = true })
      else
        print("formatting with " .. formatter[1])
        require("conform").format({
          async = true,
          formatters = formatter,
          lsp_fallback = false,
        })
      end
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
