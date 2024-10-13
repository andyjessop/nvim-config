return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		-- At the top of your linting or formatting configuration file
		local utils = require("andy.plugins.lsp.utils")

		-- Later in your code, you can use the function like this:
		local config = utils.detect_project_config()
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				if config == "biome" then
					lint.try_lint("biome")
				else
					lint.try_lint()
				end
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			if config == "biome" then
				lint.try_lint("biome")
			else
				lint.try_lint()
			end
		end, { desc = "Trigger linting for current file" })
	end,
}
