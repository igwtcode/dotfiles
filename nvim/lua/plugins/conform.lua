return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    config = function()
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
          prettier = {
            command = "prettier",
            stdin = false,
            args = {
              "--stdin-filepath",
              "$FILENAME",
              "--semi",
              "false",
              "--single-quote",
              "false",
              "--tab-width",
              "2",
              "--trailing-comma",
              "es5",
              "--print-width",
              "180",
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
          yaml = { "prettier" },
          ["yaml.cfn"] = { "prettier" },
          ["yaml.sam"] = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          markdown = { "prettier" },
          ["markdown.mdx"] = { "prettier" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          handlebars = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
      })
    end,
  },
}
