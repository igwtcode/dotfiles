local h = require("utils.helpers")

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    -- lazy = true,
    -- ft = "markdown",
    -- event = {
    --   "BufReadPre " .. vim.fn.expand("~") .. "/second-brain/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local obsidian = require("obsidian")

      obsidian.setup({
        workspaces = {
          {
            name = "second-brain",
            path = "~/second-brain",
          },
        },

        disable_frontmatter = true,
        notes_subdir = "notes",
        new_notes_location = "notes_subdir",

        daily_notes = {
          folder = "notes",
          date_format = "%Y-%m-%d-%a",
          template = "daily.md",
        },

        templates = {
          folder = "templates",
          date_format = "%Y-%m-%d-%a",
          time_format = "%H:%M",
        },

        note_id_func = function(title)
          return title
          -- return h.toLowerKebabCase(title)
        end,

        follow_url_func = function(url)
          vim.fn.jobstart({ "open", url }) -- Mac OS
        end,
      })
    end,
  },
}
