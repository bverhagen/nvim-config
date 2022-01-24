-- Install packer if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  local rtp_addition = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
  if not string.find(vim.o.runtimepath, rtp_addition) then
    vim.o.runtimepath = rtp_addition .. ',' .. vim.o.runtimepath
  end
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Load plugins
return require('packer').startup(function(use)
  -- Let packer manage itself
  use 'wbthomason/packer.nvim'

  -- Fuzzy searching
  use {'junegunn/fzf', run = function() fn['fzf#install']() end}
  use {'junegunn/fzf.vim', config = vim.cmd('source $HOME/.config/nvim/lua/fzf.vimrc')}

  -- Autocompletion helper
  use {'hrsh7th/nvim-cmp',
    branch = 'main',
    requires = {
      {'hrsh7th/cmp-nvim-lsp', branch = 'main'},
      {'hrsh7th/cmp-buffer', branch = 'main'}
    },
    config = function() require('nvim-cmp') end,
  }

  -- LSP support
  use {'neovim/nvim-lspconfig', config = function() require('nvim-lspconfig') end }

  -- Fuzzy LSP support
  use {
    'ojroques/nvim-lspfuzzy',
    requires = {
      {'junegunn/fzf'},
      {'junegunn/fzf.vim'},  -- to enable preview (optional)
    },
    config = function() require('lspfuzzy').setup {
      save_last = true
    } end
  }

  -- Automatically comment stuff
  use {'scrooloose/nerdcommenter'}

  -- Snippets manager
  use {'SirVer/ultisnips', config = function() require('ultisnips') end}

  -- Color scheme
  use { 'morhetz/gruvbox',
    config = function()
      vim.g.gruvbox_italic = 1
    end
  }

  -- Highlight C++
  --use { 'jackguo380/vim-lsp-cxx-highlight' }
  use {'arakashic/chromatica.nvim',
    ft = { 'cpp' },
    run = function() fn[':UpdateRemotePlugins']() end,
    config = vim.cmd([[
      let g:chromatica#enable_at_startup=1
      let g:chromatica#responsive_mode=1
    ]])
    --config = function()
      --vim.g.chromatica.enable_at_startup = 1
      --vim.g.chromatica.responsive_mode = 1
    --end
  }

  -- Dart support
  use { 'dart-lang/dart-vim-plugin', ft = { 'dart' } }

  -- QML support
  use { 'peterhoeg/vim-qml', ft = { 'qml' } }

  -- UNIX commands from the vim command mode
  use { 'tpope/vim-eunuch' }

  -- Jump around files more easily
  use { 'easymotion/vim-easymotion',
    config = function()
      vim.g.cpp_member_variable_highlight = 1
      vim.g.cpp_experimental_template_highlight = 1
    end
  }

  -- Use git from within vim
  use { 'tpope/vim-fugitive' }

  -- Use a more powerful status bar
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
    config = function()
      require('lualine').setup({
        options = {theme = 'gruvbox'}
      })
    end
  }

  -- Show indentations
  use { 'nathanaelkane/vim-indent-guides',
    config = function()
      vim.g.indent_guides_enable_on_vim_startup = 1
    end
  }

  use { 'tpope/vim-dispatch' }
  use { 'tpope/vim-abolish' }

  -- Highlight spurious white space
  use { 'csexton/trailertrash.vim' }

  -- Highlight yanks
  use {'machakann/vim-highlightedyank',
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
