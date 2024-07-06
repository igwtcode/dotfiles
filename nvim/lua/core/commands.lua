local lint = require("lint")
local conform = require("conform")
local h = require("utils.helpers")

vim.filetype.add({
  pattern = {
    [".*/playbooks/.*.yaml"] = "yaml.ansible",
    [".*/roles/.*.yaml"] = "yaml.ansible",
    ["playbook.yaml"] = "yaml.ansible",
    [".github/.*.yaml"] = "yaml.github",
    [".github/workflows/.*.yaml"] = "yaml.github",
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  pattern = { "*.yaml", "*.yml" },
  callback = h.set_aws_cloudformation_schemas,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yaml", "*.yml" },
  callback = h.set_aws_cloudformation_fileTypes,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("autoformat", {}),
  pattern = "*",
  desc = "Run conform pre save",
  callback = function()
    conform.format()
  end,
})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("autolint", { clear = true }),
  pattern = "*",
  desc = "Run lint on read and write",
  callback = function()
    lint.try_lint()
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "Highlight selsection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("WinResize", { clear = true }),
  pattern = "*",
  command = "wincmd =",
  desc = "Auto-resize windows on terminal buffer resize.",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("edit_text", { clear = true }),
  pattern = { "gitcommit", "markdown", "txt" },
  desc = "Enable spell checking and text wrapping for certain filetypes",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en"
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("vertical_help", { clear = true }),
  pattern = "help",
  desc = "Show help windows vertically",
  callback = function()
    vim.bo.bufhidden = "unload"
    vim.cmd.wincmd("L")
    vim.cmd.wincmd("=")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "go to last loc when opening a buffer",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dap-float",
    "fugitive",
    "help",
    "man",
    "notify",
    "null-ls-info",
    "qf",
    "PlenaryTestPopup",
    "startuptime",
    "query",
    "spectre_panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "close certain windows with q",
})
vim.api.nvim_create_autocmd("FileType", { pattern = "man", command = [[nnoremap <buffer><silent> q :quit<CR>]] })

-- https://github.com/hashicorp/terraform-ls/blob/main/docs/USAGE.md
-- expects a terraform filetype and not a tf filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.tf" },
  callback = function()
    vim.api.nvim_command("set filetype=terraform")
  end,
  desc = "detect terraform filetype",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "terraform-vars",
  callback = function()
    vim.api.nvim_command("set filetype=hcl")
  end,
  desc = "detect terraform vars",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].commentstring = "# %s"
  end,
  pattern = { "*tf", "*.hcl" },
  desc = "fix terraform and hcl comment string",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true }),
  command = [[:%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

-- toggle diagnostics
vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  if vim.g.diagnostics_enabled == nil then
    vim.g.diagnostics_enabled = false
    vim.diagnostic.enable(false)
  elseif vim.g.diagnostics_enabled then
    vim.g.diagnostics_enabled = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_enabled = true
    vim.diagnostic.enable()
  end
end, {})

-- copy file path to clipboard
vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, {})

-- rotate windows
vim.api.nvim_create_user_command("RotateWindows", function()
  local ignored_filetypes = { "neo-tree", "fidget", "Outline", "toggleterm", "qf", "notify" }
  local window_numbers = vim.api.nvim_tabpage_list_wins(0)
  local windows_to_rotate = {}

  for _, window_number in ipairs(window_numbers) do
    local buffer_number = vim.api.nvim_win_get_buf(window_number)
    local filetype = vim.bo[buffer_number].filetype

    if not vim.tbl_contains(ignored_filetypes, filetype) then
      table.insert(windows_to_rotate, { window_number = window_number, buffer_number = buffer_number })
    end
  end

  local num_eligible_windows = vim.tbl_count(windows_to_rotate)

  if num_eligible_windows == 0 then
    return
  elseif num_eligible_windows == 1 then
    vim.api.nvim_err_writeln("There is no other window to rotate with.")
    return
  elseif num_eligible_windows == 2 then
    local firstWindow = windows_to_rotate[1]
    local secondWindow = windows_to_rotate[2]

    vim.api.nvim_win_set_buf(firstWindow.window_number, secondWindow.buffer_number)
    vim.api.nvim_win_set_buf(secondWindow.window_number, firstWindow.buffer_number)
  else
    vim.api.nvim_err_writeln("You can only swap 2 open windows. Found " .. num_eligible_windows .. ".")
  end
end, {})

-- Ensure cursor shape is restored to default after exiting Neovim
-- if vim.fn.has('nvim') == 1 then
--   vim.api.nvim_create_autocmd('VimLeave', {
--     pattern = '*',
--     command = 'set guicursor=a:ver25-blinkon1',
--   })
-- end

vim.api.nvim_create_autocmd("ExitPre", {
  group = vim.api.nvim_create_augroup("Exit", { clear = true }),
  desc = "Reset cursor shape on exit",
  command = "set guicursor=a:hor25-blinkon1",
})
