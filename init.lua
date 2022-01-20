--vim.cmd('source /.vim/vimrc')

vim.g.mapleader = "-"

require('options')
require('plugins')
require('keymaps')

pcall(
  vim.cmd,
  'colorscheme gruvbox'
)
