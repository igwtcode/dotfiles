-- disable netrw (file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.skip_ts_context_commentstring_module = true

-- allow backspace on indent, end of line or insert mode start position
vim.opt.backspace = "indent,eol,start"

-- indent wrapped lines
vim.opt.breakindent = true

-- use system clipboard
vim.opt.clipboard:append("unnamedplus")

-- no space in the neovim command line for displaying messages
vim.opt.cmdheight = 1

-- set color column
-- vim.opt.colorcolumn = "120"

-- completion options
vim.opt.completeopt = "menuone,noinsert,noselect"

-- so that I can see `` in markdown files
vim.opt.conceallevel = 0

-- highlight the current line
vim.opt.cursorline = true

-- the encoding displayed
vim.opt.encoding = "utf-8"

-- the encoding written to a file
vim.opt.fileencoding = "utf-8"

-- disable error bells
vim.opt.errorbells = false

-- fold based on treesitter
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- open all folds by default
vim.opt.foldlevel = 99
-- fold based on expression
vim.opt.foldmethod = "expr"

-- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- allow hidden buffers
vim.opt.hidden = true

-- highlight all matches on previous search pattern
vim.opt.hlsearch = true

-- ignore case in search patterns
vim.opt.ignorecase = true

-- show search matches as you type
vim.opt.incsearch = true

-- hyphenated words recognized by searches
vim.opt.iskeyword:append("-")

-- companion to wrap don't split words
vim.opt.linebreak = true

-- allow the mouse to be used in neovim
vim.opt.mouse = "a"

-- set numbered lines
vim.opt.number = true

-- set number column width to 4
vim.opt.numberwidth = 4

-- set relative numbered lines
vim.opt.relativenumber = true

-- always show sign column
vim.opt.signcolumn = "yes"

-- pop up menu height
vim.opt.pumheight = 12

-- minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 12
-- minimal number of screen columns either side of cursor if wrap is `false`
vim.opt.sidescrolloff = 12

-- don't give |ins-completion-menu| messages
vim.opt.shortmess:append("c")

-- not show things like -- INSERT
vim.opt.showmode = false

-- hide tabline on top (filename)
vim.opt.showtabline = 0

-- smart case sensitivity
vim.opt.smartcase = true

-- make indenting smarter again
vim.opt.smartindent = true

-- copy indent from current line
vim.opt.autoindent = true

-- convert tabs to spaces
vim.opt.expandtab = true

-- the number of spaces inserted for each indentation
vim.opt.shiftwidth = 2

-- the number of spaces inserted for a tab
vim.opt.softtabstop = 2

-- insert 2 spaces for a tab
vim.opt.tabstop = 2

-- force all horizontal splits to go below current window
vim.opt.splitbelow = true

-- force all vertical splits to go to the right of current window
vim.opt.splitright = true

-- set term gui colors (most terminals support this)
vim.opt.termguicolors = true

-- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.timeoutlen = 500

-- no backup file
vim.opt.backup = false

-- don't create a swapfile
vim.opt.swapfile = false

-- separate vim plugins from neovim in case vim still in use
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

-- enable persistent undo
vim.opt.undofile = true

-- set an undo directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- faster completion (4000ms default)
vim.opt.updatetime = 500

-- display lines as one long line
vim.opt.wrap = false

-- if a file is being edited by another program (or was written to file while editing with another program) it is not allowed to be edited
vim.opt.writebackup = false

vim.opt.guicursor = {
  "a:block", -- All modes
  -- "n-v-c:block", -- Normal, visual, command-line: block cursor
  -- "i-ci-ve:ver25", -- Inset, command-line insert, visual-exclude: vertical bar cusor with 25% width
  -- "r-cr:hor20", -- Rplace, command-line replace: horizontal bar cursor with 20% height
  -- "o:hor50", -- Operato-pending: horizontal bar cursor with 50% height
  -- "a:ver25-blinkon1",       -- All modes: blinking settings
  -- "sm:hor50-blinkon1",      -- Showmatch: block cursor with specific blinking settings
}

-- allow buffer to be modified
-- vim.opt.modifiable = true
-- which "horizontal" keys are allowed to travel to prev/next line
-- vim.opt.whichwrap = "bs<>[]hl"
