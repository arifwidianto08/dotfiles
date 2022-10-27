-- set leader key to space
vim.g.mapleader = " "


-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]


packer.startup(function(use)


  use 'wbthomason/packer.nvim'
  -- use {
  --   'svrana/neosolarized.nvim',
  --   requires = { 'tjdevries/colorbuddy.nvim' }
  -- }
  use 'nvim-lualine/lualine.nvim' -- Statusline
  use 'nvim-lua/plenary.nvim' -- Common utilities
  use 'onsails/lspkind-nvim' -- vscode-like pictograms
  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'williamboman/nvim-lsp-installer' -- LSP Installer
  use 'neovim/nvim-lspconfig' -- LSP
  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use("szw/vim-maximizer") -- maximizes and restores current window
  use("christoomey/vim-tmux-navigator") -- tmux & split window navigation

  use "lukas-reineke/indent-blankline.nvim" -- Enable Indentation Color
  use("hrsh7th/cmp-path") -- source for file system paths

  -- snippets
  use("L3MON4D3/LuaSnip") -- snippet engine
  use("saadparwaiz1/cmp_luasnip") -- for autocompletion
  use 'glepnir/lspsaga.nvim' -- LSP UIs
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use 'kyazdani42/nvim-web-devicons' -- File icons
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'
  -- auto closing
  use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

  -- git integration
  use "lewis6991/gitsigns.nvim" -- show line modifications on left hand side

  use 'norcalli/nvim-colorizer.lua'
  use 'folke/zen-mode.nvim'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'akinsho/nvim-bufferline.lua'
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  -- use 'github/copilot.vim'

  use 'dinhhuy258/git.nvim' -- For git blame & browse
  use 'folke/tokyonight.nvim' -- Tokyonight theme
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use "Djancyp/better-comments.nvim" -- Better Comment

  if packer_bootstrap then
    require("packer").sync({
      ensure_dependencies  = true, -- Should packer install plugin dependencies?
      snapshot             = nil, -- Name of the snapshot you would like to load at startup
      snapshot_path        = join_paths(stdpath 'cache', 'packer.nvim'), -- Default save directory for snapshots
      package_root         = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack'),
      compile_path         = util.join_paths(vim.fn.stdpath('config'), 'plugin', 'packer_compiled.lua'),
      plugin_package       = 'packer', -- The default package for plugins
      max_jobs             = nil, -- Limit the number of simultaneous jobs. nil means no limit
      auto_clean           = true, -- During sync(), remove unused plugins
      compile_on_sync      = true, -- During sync(), run packer.compile()
      disable_commands     = false, -- Disable creating commands
      opt_default          = false, -- Default to using opt (as opposed to start) plugins
      transitive_opt       = true, -- Make dependencies of opt plugins also opt by default
      transitive_disable   = true, -- Automatically disable dependencies of disabled plugins
      auto_reload_compiled = true, -- Automatically reload the compiled file after creating it.
      preview_updates      = false, -- If true, always preview updates before choosing which plugins to update, same as `PackerUpdate --preview`.
      git                  = {
        cmd = 'git', -- The base command for git operations
        subcommands = { -- Format strings for git subcommands
          update         = 'pull --ff-only --progress --rebase=false',
          install        = 'clone --depth %i --no-single-branch --progress',
          fetch          = 'fetch --depth 999999 --progress',
          checkout       = 'checkout %s --',
          update_branch  = 'merge --ff-only @{u}',
          current_branch = 'branch --show-current',
          diff           = 'log --color=never --pretty=format:FMT --no-show-signature HEAD@{1}...HEAD',
          diff_fmt       = '%%h %%s (%%cr)',
          get_rev        = 'rev-parse --short HEAD',
          get_msg        = 'log --color=never --pretty=format:FMT --no-show-signature HEAD -n 1',
          submodules     = 'submodule update --init --recursive --progress'
        },
        depth = 1, -- Git clone depth
        clone_timeout = 60, -- Timeout, in seconds, for git clones
        default_url_format = 'https://github.com/%s' -- Lua format string used for "aaa/bbb" style plugins
      },
      display              = {
        non_interactive = false, -- If true, disable display windows for all operations
        compact         = false, -- If true, fold updates results by default
        open_fn         = nil, -- An optional function to open a window for packer's display
        open_cmd        = '65vnew \\[packer\\]', -- An optional command to open a window for packer's display
        working_sym     = '⟳', -- The symbol for a plugin being installed/updated
        error_sym       = '✗', -- The symbol for a plugin with an error in installation/updating
        done_sym        = '✓', -- The symbol for a plugin which has completed installation/updating
        removed_sym     = '-', -- The symbol for an unused plugin which was removed
        moved_sym       = '→', -- The symbol for a plugin which was moved (e.g. from opt to start)
        header_sym      = '━', -- The symbol for the header line in packer's display
        show_all_info   = true, -- Should packer show all update details automatically?
        prompt_border   = 'double', -- Border style of prompt popups.
        keybindings     = { -- Keybindings for the display window
          quit = 'q',
          toggle_update = 'u', -- only in preview
          continue = 'c', -- only in preview
          toggle_info = '<CR>',
          diff = 'd',
          prompt_revert = 'r',
        }
      },
      luarocks             = {
        python_cmd = 'python' -- Set the python command to use for running hererocks
      },
      log                  = { level = 'warn' }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
      profile              = {
        enable = false,
        threshold = 1, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
      },
      autoremove           = false, -- Remove disabled or unused plugins without prompting the user
    })

    -- require('nvim-comment').setup({ comment_empty = false, })

    require 'nvim-treesitter.configs'.setup {
      context_commentstring = {
        enable = true,
        config = {
          javascript = {
            __default = '// %s',
            jsx_element = '{/* %s */}',
            jsx_fragment = '{/* %s */}',
            jsx_attribute = '// %s',
            comment = '// %s'
          }
        }
      }
    }

    require('better-comment').Setup()

    require("indent_blankline").setup {
      -- for example, context is off by default, use this to turn it on
      space_char_blankline = " ",
      show_current_context = true,
      show_current_context_start = true,
      show_end_of_line = true,
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      }
    }

  end

end)
