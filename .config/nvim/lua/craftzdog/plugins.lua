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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  --buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
end


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
  use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig' -- LSP
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
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-telescope/telescope.nvim'
  -- use 'nvim-telescope/telescope-file-browser.nvim'
  -- auto closing
  use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags


  use 'nvim-tree/nvim-web-devicons' -- Dev Icons for nvim-tree
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  }

  -- git integration
  use "lewis6991/gitsigns.nvim" -- show line modifications on left hand side

  use 'norcalli/nvim-colorizer.lua'
  use 'folke/zen-mode.nvim'
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'akinsho/nvim-bufferline.lua'

  use 'jose-elias-alvarez/typescript.nvim' -- Typescript
  -- use 'github/copilot.vim'

  use 'dinhhuy258/git.nvim' -- For git blame & browse
  use 'folke/tokyonight.nvim' -- Tokyonight theme
  use 'JoosepAlviste/nvim-ts-context-commentstring'
  use "Djancyp/better-comments.nvim" -- Better Comment
  use 'mg979/vim-visual-multi'

  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use "rafamadriz/friendly-snippets"
  use 'ggandor/leap.nvim' -- Leap

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


    require('better-comment').Setup()

    require("indent_blankline").setup {
      space_char_blankline = " ",
      buftype_exclude = { "terminal" },
      filetype_exclude = { "dashboard", "NvimTree", "packer", "lsp-installer" },
      show_current_context = true,
      show_current_context_start = true,
      context_patterns = {
        "class", "return", "function", "method", "^if", "^while", "jsx_element", "^for", "^object",
        "^table", "block", "arguments", "if_statement", "else_clause", "tsx_element",
        "jsx_self_closing_element", "tsx_self_closing_element", "try_statement", "catch_clause", "import_statement",
        "operation_type"
      }
    }


    require("typescript").setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
      },
      server = { -- pass options to lspconfig's setup method
        on_attach = on_attach
      },
    })

    require('gitsigns').setup({
      signs                        = {
        add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      },
      signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        interval = 1000,
        follow_files = true
      },
      attach_to_untracked          = true,
      current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil, -- Use default
      max_file_length              = 40000, -- Disable if file is longer than this (in lines)
      preview_config               = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
      yadm                         = {
        enable = false
      },
    })

    -- Setup icon for nvim-tree
    require 'nvim-web-devicons'.setup({
      -- your personnal icons can go here (to override)
      -- you can specify color or cterm_color instead of specifying both of them
      -- DevIcon will be appended to `name`
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
      };
      -- globally enable different highlight colors per icon (default to true)
      -- if set to false all icons will have the default icon's color
      color_icons = true;
      -- globally enable default icons (default to false)
      -- will get overriden by `get_icons` option
      default = true;
    })

    require('leap').add_default_mappings()

  end
end)
