local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
}, {
  concurrency = 18,
  checker = {
    enabled = true,
    notify = false,
    concurrency = 27,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = "rounded",
    backdrop = 89,
  },
})
