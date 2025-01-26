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

  -- LSP support
  use {'neovim/nvim-lspconfig', config = function() require('nvim-lspconfig') end }

  -- Fuzzy LSP support
  --use {
    --'ojroques/nvim-lspfuzzy',
    --requires = {
      --{'junegunn/fzf'},
      --{'junegunn/fzf.vim'},  -- to enable preview (optional)
    --},
    --config = function() require('lspfuzzy').setup {
      --save_last = true
    --} end
  --}

  -- Automatically comment stuff
  use {'scrooloose/nerdcommenter'}

  -- Snippets manager
  --use {'SirVer/ultisnips', config = function() require('ultisnips') end}

  -- Color scheme

  use { 'luisiacc/gruvbox-baby',
    config = function()
    end
  }

  -- Highlight support using treesitter
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function() require('treesitter') end }

  -- Dart support
  --use { 'dart-lang/dart-vim-plugin', ft = { 'dart' } }

  -- Flutter tools support
  use {
    'akinsho/flutter-tools.nvim',
    requires = {
        'nvim-lua/plenary.nvim',
    },
    config = function() require("flutter-tools").setup{} end
  }

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
        options = {theme = 'gruvbox-baby'}
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

  -- Enable Github Copilot
  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          panel = { enabled = false },
          suggestion = { enabled = false },
          filetypes = { cpp = true }, 
        })
      end, 100)
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup {
        --method = "getCompletionsCycling",
      }
    end
  }

  -- Autocompletion helper
  use {'hrsh7th/nvim-cmp',
    branch = 'main',
    requires = {
      {'hrsh7th/cmp-nvim-lsp', branch = 'main'},
      {'hrsh7th/cmp-buffer', branch = 'main'}
    },
    config = function()
      local cmp = require'cmp'

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            --vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
             --vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            -- this is the important line
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
        }),
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          --{ name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
           --{ name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  }

  use {'kevinhwang91/nvim-bqf', ft = 'qf'}

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)
