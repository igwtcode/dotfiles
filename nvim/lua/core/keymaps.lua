local conform = require("conform")
local todoComments = require("todo-comments")
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
local ufo = require("ufo")
local sprectre = require("spectre")
local h = require("utils.helpers")

local M = {}

h.nnoremap("<leader>e", "<cmd>Oil<CR>", { desc = "Explorer" })
h.nnoremap("<leader>w", "<cmd>w<cr>", { silent = false, desc = "Save/Write" })
-- h.nnoremap("<leader>wa", "<cmd>wa<cr>", { silent = false, desc = "Save/Write All" })
h.nnoremap("<leader>q", "<cmd>q<cr>", { silent = false, desc = "Quit" })
-- h.nnoremap("<leader>qa", "<cmd>qa<cr>", { silent = false, desc = "Quit All" })
h.nnoremap("<leader>r", "<cmd>RotateWindows<cr>", { desc = "Rotate Windows" })
h.nnoremap("<leader>m", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
h.nnoremap("<leader>lg", "<cmd>LazyGit<CR>", { desc = "Lazygit" })
h.nnoremap("<leader>bd", "<cmd>bd<CR>", { desc = "Buffer Delete" })
h.nnoremap("<leader>bn", "<cmd>bnext<CR>", { desc = "Buffer Next" })
h.nnoremap("<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer Previous" })
h.nnoremap("<leader>sv", "<C-w>v", { desc = "Split vertically" })
h.nnoremap("<leader>sh", "<C-w>s", { desc = "Split horizontally" })
h.nnoremap("<leader>se", "<C-w>=", { desc = "Make splits equal size" })
h.nnoremap("<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
h.nnoremap("<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
h.nnoremap("<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
h.nnoremap("<leader>no", "<cmd>noh<cr>", { desc = "No Highlight" })
h.nnoremap("<leader>vv", "<cmd>vert diffsplit version.yml<CR>", { desc = "Compare Versions" })

h.nnoremap("<leader>cf", function()
  conform.format()
end, { desc = "Format file" })
h.vnoremap("<leader>cf", function()
  conform.format()
end, { desc = "Format file or range (visual mode)" })

h.nnoremap("<leader>sr", function()
  sprectre.open()
end, { desc = "Replace in Files (Spectre)" })

h.nnoremap("H", "^", { desc = "Start of line" })
h.nnoremap("L", "$", { desc = "End of line" })
h.nnoremap("U", "<C-r>", { desc = "Redo" })
h.vnoremap("<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
h.vnoremap("<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

h.nnoremap("zR", ufo.openAllFolds)
h.nnoremap("zM", ufo.closeAllFolds)
h.nnoremap("zr", ufo.openFoldsExceptKinds)
h.nnoremap("zm", ufo.closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

h.nnoremap("<leader><leader>", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
h.nnoremap("<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Find in current buffer" })
h.nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
h.nnoremap("<leader>fD", "<cmd>Telescope diagnostics<CR>", { desc = "Find Diagnostics" })
h.nnoremap("<leader>fd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Find LSP Definitions" })
h.nnoremap("<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Find grep" })
h.nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find grep" })
h.nnoremap("<leader>fi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Find LSP Implementations" })
h.nnoremap("<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
h.nnoremap("<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Find recent files" })
h.nnoremap("<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "Find LSP References" })
h.nnoremap("<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Document Symbols" })
h.nnoremap("<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
h.nnoremap("<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

h.nnoremap("<leader>cc", "<cmd>Telescope conventional_commits<CR>", { desc = "Conventional Commit" })
h.nnoremap("<leader>ss", "<cmd>Telescope spell_suggest<CR>", { desc = "Search Spelling suggestions" })

h.nnoremap("<leader>fm", function()
  View_messages()
end, { desc = "Find Messages" })

h.nnoremap("<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Open/close trouble list" })
h.nnoremap(
  "<leader>xw",
  "<cmd>TroubleToggle workspace_diagnostics<CR>",
  { desc = "Open trouble workspace diagnostics" }
)
h.nnoremap("<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Open trouble document diagnostics" })
h.nnoremap("<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Open trouble quickfix list" })
h.nnoremap("<leader>xl", "<cmd>TroubleToggle loclist<CR>", { desc = "Open trouble location list" })
h.nnoremap("<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "Open todos in trouble" })

h.nnoremap("<leader>ld", vim.diagnostic.setqflist, { desc = "Quickfix List Diagnostics" })
h.nnoremap("<leader>cn", ":cnext<cr>zz", { desc = "Next Quickfix" })
h.nnoremap("<leader>cp", ":cprevious<cr>zz", { desc = "Previous Quickfix" })
h.nnoremap("<leader>co", ":copen<cr>zz", { desc = "Open Quickfix" })
-- h.nnoremap("<leader>cc", ":cclose<cr>zz", { desc = "Close Quickfix" })

-- Center buffer while navigating
h.nnoremap("<C-u>", "<C-u>zz")
h.nnoremap("<C-d>", "<C-d>zz")
h.nnoremap("<C-i>", "<C-i>zz")
h.nnoremap("<C-o>", "<C-o>zz")
h.nnoremap("{", "{zz")
h.nnoremap("}", "}zz")
h.nnoremap("N", "Nzz")
h.nnoremap("n", "nzz")
h.nnoremap("G", "Gzz")
h.nnoremap("gg", "ggzz")
h.nnoremap("%", "%zz")
h.nnoremap("*", "*zz")
h.nnoremap("#", "#zz")

-- Press gx to open the link under the cursor
h.nnoremap("gx", ":sil !open <cWORD><cr>", { silent = true })

-- Harpoon keybinds --
-- Open harpoon ui
h.nnoremap("<leader>ho", function()
  harpoon_ui.toggle_quick_menu()
end)

-- Add current file to harpoon
h.nnoremap("<leader>ha", function()
  harpoon_mark.add_file()
end)

-- Remove current file from harpoon
h.nnoremap("<leader>hr", function()
  harpoon_mark.rm_file()
end)

-- Remove all files from harpoon
h.nnoremap("<leader>hc", function()
  harpoon_mark.clear_all()
end)

-- Quickly jump to harpooned files
h.nnoremap("<leader>1", function()
  harpoon_ui.nav_file(1)
end)

h.nnoremap("<leader>2", function()
  harpoon_ui.nav_file(2)
end)

h.nnoremap("<leader>3", function()
  harpoon_ui.nav_file(3)
end)

h.nnoremap("<C-j>", function()
  if vim.fn.exists(":NvimTmuxNavigateDown") ~= 0 then
    vim.cmd.NvimTmuxNavigateDown()
  else
    vim.cmd.wincmd("j")
  end
end, { desc = "Navigate Down" })

h.nnoremap("<C-k>", function()
  if vim.fn.exists(":NvimTmuxNavigateUp") ~= 0 then
    vim.cmd.NvimTmuxNavigateUp()
  else
    vim.cmd.wincmd("k")
  end
end, { desc = "Navigate Up" })

h.nnoremap("<C-l>", function()
  if vim.fn.exists(":NvimTmuxNavigateRight") ~= 0 then
    vim.cmd.NvimTmuxNavigateRight()
  else
    vim.cmd.wincmd("l")
  end
end, { desc = "Navigate Right" })

h.nnoremap("<C-h>", function()
  if vim.fn.exists(":NvimTmuxNavigateLeft") ~= 0 then
    vim.cmd.NvimTmuxNavigateLeft()
  else
    vim.cmd.wincmd("h")
  end
end, { desc = "Navigate Left" })

h.nnoremap("[d", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ALL })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Next Diagnostic" })

h.nnoremap("]d", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ALL })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Previous Diagnostic" })

h.nnoremap("[e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Next Error" })

h.nnoremap("]e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Previous Error" })

h.nnoremap("[w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Next Warning" })

h.nnoremap("]w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Previous Warning" })

h.nnoremap("[t", function()
  todoComments.jump_next()
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Next Todo" })

h.nnoremap("]t", function()
  todoComments.jump_prev()
  vim.api.nvim_feedkeys("zz", "n", false)
end, { desc = "Previous Todo" })

h.nnoremap("<leader>d", function()
  vim.diagnostic.open_float({
    border = "rounded",
  })
end, { desc = "Open Diagnostic" })

M.map_lsp_keybinds = function(buf_num)
  local buf = vim.lsp.buf
  local tb = require("telescope.builtin")

  h.nnoremap("<leader>rn", buf.rename, { desc = "LSP: Rename", buffer = buf_num })
  h.nnoremap("<leader>ca", buf.code_action, { desc = "LSP: Code Action", buffer = buf_num })
  h.nnoremap("gd", buf.definition, { desc = "LSP: Goto Definition", buffer = buf_num })
  h.nnoremap("gD", buf.declaration, { desc = "LSP: Goto Declaration", buffer = buf_num })
  h.nnoremap("td", buf.type_definition, { desc = "LSP: Type Definition", buffer = buf_num })
  h.nnoremap("gr", tb.lsp_references, { desc = "LSP: Goto References", buffer = buf_num })
  h.nnoremap("gi", tb.lsp_implementations, { desc = "LSP: Goto Implementations", buffer = buf_num })
  h.nnoremap("<leader>ds", tb.lsp_document_symbols, { desc = "LSP: Document Symbols", buffer = buf_num })
  h.nnoremap("<leader>ws", tb.lsp_workspace_symbols, { desc = "LSP: Workspace Symbols", buffer = buf_num })
  h.nnoremap("K", buf.hover, { desc = "LSP: Hover Documentation", buffer = buf_num })
  h.nnoremap("<leader>k", buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buf_num })
  h.inoremap("<C-k>", buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buf_num })
end

h.xnoremap("<<", function()
  -- Move selected text up/down in visual mode
  vim.cmd("normal! <<")
  vim.cmd("normal! gv")
end)

h.xnoremap(">>", function()
  vim.cmd("normal! >>")
  vim.cmd("normal! gv")
end)

-- greatest remap ever
-- replace the selected text with the copied text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gc<Left><Left><Left>]])
-- h.nnoremap("<leader>e", "<cmd>Oil --float<CR>", { desc = "Explorer" })

return M
