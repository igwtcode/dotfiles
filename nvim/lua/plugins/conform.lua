return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
      local home = os.getenv("HOME")
      local prettier_config_path = home .. "/.config/prettier/.prettierrc"

      require("conform").setup({
        notify_on_error = true,
        format = {
          lsp_fallback = true,
          async = false,
          quiet = false,
          timeout_ms = 1000,
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          quiet = false,
          timeout_ms = 1000,
        },
        formatters = {
          custom_prettier = {
            command = "prettier",
            stdin = true,
            args = {
              "--stdin-filepath",
              "$FILENAME",
              "--config",
              prettier_config_path,
              "--write",
            },
          },
          shfmt = {
            prepend_args = { "-i", "2" },
          },
          autopep8 = {
            command = "autopep8",
            args = {
              "--max-line-length",
              "180",
              "--aggressive",
              "--aggressive",
              "-", -- Read from stdin
            },
            stdin = true,
          },
        },
        formatters_by_ft = {
          go = { "goimports", "gofmt" },
          python = { "autopep8" },
          terraform = { "terraform_fmt" },
          tf = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          sh = { "shfmt" },
          lua = { "stylua" },
          yaml = { "custom_prettier" },
          ["yaml.cfn"] = { "custom_prettier" },
          ["yaml.sam"] = { "custom_prettier" },
          json = { "custom_prettier" },
          jsonc = { "custom_prettier" },
          markdown = { "prettier" },
          ["markdown.mdx"] = { "prettier" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          vue = { "prettier" },
          handlebars = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
      })
    end,
  },
}
