return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = vim.fn.executable("make") == 1 and "make"
          or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons", "folke/todo-comments.nvim" },
      },
      "olacin/telescope-cc.nvim",
      "folke/todo-comments.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local transform_mod = require("telescope.actions.mt").transform_mod
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local sorters = require("telescope.sorters")

      function View_messages()
        local messages = vim.fn.execute("messages")
        local lines = vim.split(messages, "\n")

        pickers
          .new({ initial_mode = "normal" }, {
            prompt_title = "Messages",
            finder = finders.new_table({
              results = lines,
            }),
            sorter = sorters.get_generic_fuzzy_sorter(),
          })
          :find()
      end

      local trouble = require("trouble")
      local trouble_telescope = require("trouble.sources.telescope")

      -- or create your custom action
      local custom_actions = transform_mod({
        open_trouble_qflist = function(prompt_bufnr)
          trouble.toggle("quickfix")
        end,
      })

      telescope.setup({
        defaults = vim.tbl_extend("force", require("telescope.themes").get_ivy(), {
          layout_config = {
            height = 0.66,
          },
          preview = {
            filesize_limit = 3, -- MB
          },
          vimgrep_arguments = {
            "rg",
            "--follow", -- Follow symbolic links
            "--hidden", -- Search for hidden files
            "--no-heading", -- Don't group matches by each file
            "--with-filename", -- Print the file path with the matched lines
            "--line-number", -- Show line numbers
            "--column", -- Show column numbers
            "--smart-case", -- Smart case search

            -- Exclude some patterns from search
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/*.zip",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },
          -- path_display = { "smart" },
          mappings = {
            n = {
              ["dd"] = actions.delete_buffer,
            },
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
              ["<C-t>"] = trouble_telescope.open,
            },
          },
        }),
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              "rg",
              "--files",
              "--hidden",
              -- "--no-ignore-vcs",
              "--glob=!**/.git/*",
              "--glob=!**/.idea/*",
              "--glob=!**/.vscode/*",
              "--glob=!**/build/*",
              "--glob=!**/dist/*",
              "--glob=!**/*.zip",
              "--glob=!**/yarn.lock",
              "--glob=!**/package-lock.json",
            },
          },
          live_grep = {
            hidden = true,
          },
          buffers = {
            sort_lastused = true,
            ignore_current_buffer = false,
            show_all_buffers = true,
            sort_mru = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({
              -- even more opts
            }),
          },
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
          },
          conventional_commits = {
            include_body_and_footer = false, -- Add prompts for commit body and footer
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("conventional_commits")
      telescope.load_extension("ui-select")
    end,
  },
}
