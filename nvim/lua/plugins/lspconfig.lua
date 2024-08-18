return {
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost" },
    -- event = { "VimEnter" },
    -- cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
    dependencies = {
      "folke/neodev.nvim",
      "folke/neoconf.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Install lsp autocompletions
      "hrsh7th/cmp-nvim-lsp",

      -- Progress/Status update for LSP
      { "j-hui/fidget.nvim", opts = {} },
      {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
      },
    },
    config = function()
      local ensure_installed = {
        "actionlint",
        "ansiblels",
        "ansible-lint",
        "autopep8",
        "bashls",
        "cfn-lint",
        "delve",
        "dockerls",
        "hadolint",
        "gopls",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "terraformls",
        "tflint",
        "tsserver",
        "yamlls",
        "go-debug-adapter",
        "js-debug-adapter",
        "eslint",
        "flake8",
        "golangci-lint",
        "jsonlint",
        "markdownlint",
        "goimports",
        "gomodifytags",
        "gofumpt",
        "prettier",
        "shfmt",
        "stylua",
      }

      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        -- ensure_installed = ensure_installed,
      })

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
      })

      require("neodev").setup({
        import = {
          vscode = false,
        },
      })

      require("neoconf").setup({})

      local lspconfig = require("lspconfig")
      -- lspconfig.ui.windows.default_options.border = "rounded"
      require("lspconfig.ui.windows").default_options.border = "rounded"

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

      local default_handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
      }

      local map_lsp_keybinds = require("core.keymaps").map_lsp_keybinds -- Has to load keymaps before pluginslsp
      -- Function to run when neovim connects to a Lsp client
      ---@diagnostic disable-next-line: unused-local
      local on_attach = function(_client, buffer_number)
        -- Pass the current buffer to map lsp keybinds
        map_lsp_keybinds(buffer_number)
      end

      lspconfig.yamlls.setup({
        capabilities = vim.tbl_deep_extend("force", capabilities, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }),
        default_handlers = default_handlers,
        on_attach = on_attach,
        filetypes = { "yaml", "yaml.ansible", "yaml.github", "yaml.cfn", "yaml.sam" },
        settings = {
          redhat = { telemetry = { enabled = false } },
          yaml = {
            keyOrdering = false,
            format = {
              enable = false,
              singleQuote = true,
              bracketSpacing = false,
              printWidth = 180,
              proseWrap = "preserve",
            },
            validate = true,
            hover = true,
            completion = true,
            schemas = require("schemastore").yaml.schemas({}),
            schemaStore = {
              enable = false,
              url = "",
            },
          },
        },
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.pyright.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.tsserver.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
        keys = {
          {
            "<leader>co",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.organizeImports.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Organize Imports",
          },
          {
            "<leader>cR",
            function()
              vim.lsp.buf.code_action({
                apply = true,
                context = {
                  only = { "source.removeUnused.ts" },
                  diagnostics = {},
                },
              })
            end,
            desc = "Remove Unused Imports",
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        settings = {
          completions = {
            completeFunctionCalls = true,
          },
        },
      })

      lspconfig.gopls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
        keys = {
          -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
          { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
        },
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = false,
              rangeVariableTypes = false,
            },
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = false,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
          },
        },
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
        -- on_new_config = function(new_config)
        --   new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        --   vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
        -- end,
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            format = {
              enable = true,
            },
            validate = { enable = true },
          },
        },
      })

      lspconfig.marksman.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.terraformls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.ansiblels.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.bashls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      lspconfig.dockerls.setup({
        capabilities = capabilities,
        default_handlers = default_handlers,
        on_attach = on_attach,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      local icons = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }

      -- Set up diagnostic signs with custom icons
      vim.fn.sign_define("DiagnosticSignError", { text = icons.Error, texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = icons.Warn, texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DiagnosticSignHint", { text = icons.Hint, texthl = "DiagnosticSignHint" })
      vim.fn.sign_define("DiagnosticSignInfo", { text = icons.Info, texthl = "DiagnosticSignInfo" })

      -- Configure diagnostics display settings
      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
        virtual_text = {
          prefix = "", -- Disable the default prefix
          source = false,
          format = function(diagnostic)
            return string.format("%s", diagnostic.message)
          end,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Set highlight groups for diagnostics
      vim.cmd([[
highlight DiagnosticSignError guifg=#f38ba8
highlight DiagnosticSignWarn guifg=#fab387
highlight DiagnosticSignHint guifg=#89dceb
highlight DiagnosticSignInfo guifg=#89b4fa
]])
    end,
  },
}
