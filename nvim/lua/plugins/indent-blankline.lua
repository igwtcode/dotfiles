return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = { "|", "¦", "┆", "┊" },
        },
        whitespace = { highlight = { "Whitespace", "NonText" } },
        exclude = {
          filetypes = {
            "startify",
            "dashboard",
            "dotooagenda",
            "log",
            "fugitive",
            "gitcommit",
            "packer",
            "vimwiki",
            "markdown",
            "json",
            "txt",
            "vista",
            "help",
            "todoist",
            "NvimTree",
            "neo-tree",
            "peekaboo",
            "git",
            "TelescopePrompt",
            "undotree",
            "flutterToolsOutline",
            "", -- for all buffers without a file type
          },
          buftypes = {
            "terminal",
            "nofile",
          },
        },
        scope = {
          enabled = false,
          char = "|",
          show_start = false,
          show_end = false,
        },
      })
    end,
  },
}
