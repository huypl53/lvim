-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

cmd = vim.cmd
function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

opt = {}

function split (inputstr, sep)
  local t={}
  if inputstr == nil or inputstr == '' then
    t[0] = ''
    return t
  end
  if sep == nil then
    sep = "%s"
  end
  local i = 0
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i+1
  end
  return t
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "onedarker"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.localleader = ";"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
-- }


vim.opt.relativenumber = true
vim.opt.ignorecase = false
-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = false
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.nvimtree.setup.update_cwd = false
-- lvim.builtin.project.active = false
lvim.builtin.project.manual_mode = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- Beautify
local components = require("lvim.core.lualine.components")
components.filename.path = 1
lvim.builtin.lualine.sections.lualine_b = {
  components.branch,
  components.filename,
}

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---@usage Select which servers should be configured manually. Requires `:LvimCacheRest` to take effect.
-- See the full default list `:lua print(vim.inspect(lvim.lsp.override))`
-- vim.list_extend(lvim.lsp.override, { "pyright" })

-- ---@usage setup a server -- see: https://www.lunarvim.org/languages/#overriding-the-default-configuration
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local opts = { noremap = true, silent = true }

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.

  -- buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<A-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- buf_set_keymap("n", "<space>le", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "<space>le", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)

  -- Set some keybinds conditional on server capabilities
  -- if client.resolved_capabilities.document_formatting then
  --    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  -- elseif client.resolved_capabilities.document_range_formatting then
  --    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  -- end
end
-- you can overwrite the null_ls setup table (useful for setting the root_dir function)
-- lvim.lsp.null_ls.setup = {
--   root_dir = require("lspconfig").util.root_pattern("Makefile", ".git", "node_modules"),
-- }
-- or if you need something more advanced
-- lvim.lsp.null_ls.setup.root_dir = function(fname)
--   if vim.bo.filetype == "javascript" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "node_modules")(fname)
--       or require("lspconfig/util").path.dirname(fname)
--   elseif vim.bo.filetype == "php" then
--     return require("lspconfig/util").root_pattern("Makefile", ".git", "composer.json")(fname) or vim.fn.getcwd()
--   else
--     return require("lspconfig/util").root_pattern("Makefile", ".git")(fname) or require("lspconfig/util").path.dirname(fname)
--   end
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { exe = "black", filetypes = { "python" } },
--   { exe = "isort", filetypes = { "python" } },
--   {
--     exe = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { exe = "flake8", filetypes = { "python" } },
--   {
--     exe = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     args = { "--severity", "warning" },
--   },
--   {
--     exe = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

----------------------------
-- Disable default plugins--
----------------------------
lvim.keys.normal_mode["<leader>h"] = nil
-- Additional Plugins
lvim.plugins = {
  ----------
  --Finder--
  ----------
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  -- {"folke/tokyonight.nvim"},
  {
    "ray-x/lsp_signature.nvim",
    config = function() require"lsp_signature".on_attach() end,
    event = "InsertEnter"
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    after="nvim-treesitter"
  },
  -- {
  --   "glepnir/lspsaga.nvim",
  --   config = function()
  --     require("lspsaga").init_lsp_saga()
  --   end
  -- },
  {
    "kosayoda/nvim-lightbulb",
    -- ignore = {"null-ls"}
  },
  {
    "onsails/lspkind-nvim",
    event = "BufEnter",
    config = function()
      require("lspkind").init()
    end
  },
  {
    "alvan/vim-closetag"
  },
  {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        }
      }
    end
  },
  {
    "ThePrimeagen/refactoring.nvim",
    after={
      "nvim-treesitter",
      "plenary.nvim",
    },
    requires = {
      {"nvim-lua/plenary.nvim"},
      {"nvim-treesitter/nvim-treesitter"}
    },
    config = function()
      require "refactoring".setup()
    end

  },
  -----------------
  --Coding helper--
  -----------------
  {
    "kevinhwang91/nvim-bqf",
    config=function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'}
        },
        func_map = {
          vsplit = '',
          ptogglemode = 'z,',
          stoggleup = ''
        },
        filter = {
          fzf = {
            action_for = {['ctrl-s'] = 'split'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', '> '}
          }
        }
      })
      vim.cmd "hi BqfPreviewBorder guifg=#50a14f ctermfg=71"
      vim.cmd "hi link BqfPreviewRange Search"
      vim.cmd "hi default link BqfPreviewFloat Normal"
      vim.cmd "hi default link BqfPreviewBorder Normal"
      vim.cmd "hi default link BqfPreviewCursor Cursor"
      vim.cmd "hi default link BqfPreviewRange IncSearch"
      vim.cmd "hi default BqfSign ctermfg=14 guifg=Cyan"
    end
  },


  {
    "tweekmonster/startuptime.vim", cmd = "StartupTime"
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    setup = function()
      vim.g.indentLine_enabled = 1
      vim.g.indent_blankline_char = "▏"

      vim.g.indent_blankline_filetype_exclude = { "help", "terminal", "dashboard", "packer" }
      vim.g.indent_blankline_buftype_exclude = { "terminal" }

      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_first_indent_level = false
      vim.g.indent_blankline_char_highlight_list = {'Method', 'Function', 'Conditional', 'Special', 'Underlined'}
    end,

  },
  {
    "rhysd/accelerated-jk"
  },
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "<leader>hc", ":HopChar2<CR>", { silent = true })
      vim.api.nvim_set_keymap("n", "<leader>hw", ":HopWord<CR>", { silent = true })
    end,
  },
  {
    "simeji/winresizer",
    config = function()

      vim.g.winresizer_start_key="<Nop>"
      map("n", "<C-e>r", ":WinResizerStartResize<CR>")
      map("n", "<C-e>m", ":WinResizerStartMove<CR>")
      map("n", "<C-e>f", ":WinResizerStartFocus<CR>")
    end
  },

  {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
      }
    end

  },
  {
    'junegunn/Limelight.vim',
    cmd = 'Limelight'
  },
  {
    "luochen1990/rainbow",
    ft = { 'html', 'css', 'javascript', 'javascriptreact', 'go', 'python', 'lua', 'rust', 'vim', 'less', 'stylus', 'sass', 'scss', 'json', 'ruby', 'toml' }

  },
  {
    "blackCauldron7/surround.nvim",
    config = function()
      require"surround".setup {mappings_style = "sandwich"}
    end
  },
  {
    "chentau/marks.nvim",
    event = "BufEnter",
    config = function()
      require'marks'.setup {
        default_mappings = true,
        builtin_marks = { ".", "<", ">", "^" },
        cyclic = true,
        force_write_shada = false,
        refresh_interval = 150,
        sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
        bookmark_0 = {
          sign = "⚑",
          virt_text = "hello world"
        },
        mappings = {
          -- preview = "m:",
          -- set_next = "m,",
        }
      }
    end
  },
  -- {
  --   'brooth/far.vim'
  -- },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    'liuchengxu/vista.vim',
  },
  {
    'simrat39/symbols-outline.nvim',
  },
  {
    "AndrewRadev/splitjoin.vim"
  },
  {
    "jpalardy/vim-slime",
    ft = {'python', 'javascript'}
  },
  {
    'hanschen/vim-ipython-cell',
    ft = {'python', 'javascript'},
    requires={'jpalardy/vim-slime',}
  },
  {
    'kkoomen/vim-doge',
    ft={'python'},
    config=function()
      vim.g.doge_doc_standard_python = 'numpy'
    end
  },
  {
    "iamcco/markdown-preview.nvim",
    ft={'markdown', 'pandoc.markdown', 'rmd', 'adoc'},
    run = 'cd app && npm install',
    cmd = 'MarkdownPreview',
    config=function()
      vim.g.mkdp_echo_preview_url=1
    end
  },
  {
    "sbdchd/neoformat",
    cmd="Neoformat"
  },
  {
    "Chiel92/vim-autoformat",
    config = function()
      vim.g.python3_host_prog="/bin/python3"
      vim.g.formatterpath="$HOME/.local/bin/black"
    end
  },
  {
    "dense-analysis/ale",
    after="nvim-lspconfig",
    config = function()
      vim.g.ale_echo_msg_error_str = 'E'
      vim.g.ale_echo_msg_warning_str = 'W'
      vim.g.ale_echo_msg_format = '[%linter%] %s [%severity%]'
      vim.g.ale_completion_enabled=0
      vim.g.ale_lint_on_text_changed = "never"
      vim.g.ale_lint_on_enter = 0
    end
  },
  {
    "t9md/vim-choosewin",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>-", "<Plug>(choosewin)", opt)
      vim.g.choosewin_overlay_enable = 1
    end
  },
  {
    "Pocco81/TrueZen.nvim",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      require("true-zen").setup{
        ui = {
          bottom = {
            laststatus = 0,
            ruler = false,
            showmode = false,
            showcmd = false,
            cmdheight = 1,
          },
          top = {
            showtabline = 0,
          },
          left = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
          },
        },
        modes = {
          ataraxis = {
            left_padding = 32,
            right_padding = 32,
            top_padding = 1,
            bottom_padding = 1,
            ideal_writing_area_width = { 0 },
            auto_padding = true,
            keep_default_fold_fillchars = true,
            custome_bg = "",
            bg_configuration = true,
            affected_higroups = {
              NonText = {},
              FoldColumn = {},
              ColorColumn = {},
              VertSplit = {},
              StatusLine = {},
              StatusLineNC = {},
              SignColumn = {},
            },
          },
          focus = {
            margin_of_error = 5,
            focus_method = "experimental",
          },
        },
        integrations = {
          vim_gitgutter = false,
          galaxyline = false,
          tmux = false,
          gitsigns = false,
          nvim_bufferline = false,
          limelight = false,
          vim_airline = false,
          vim_powerline = false,
          vim_signify = false,
          express_line = false,
          lualine = false,
        },
        misc = {
          on_off_commands = false,
          ui_elements_commands = false,
          cursor_by_mode = false,
        },
      }
    end,
    setup = function()
      map("n", "<leader>zz", ":TZAtaraxis<CR>", opt)
      map("n", "<leader>zm", ":TZMinimalist<CR>", opt)
      map("n", "<leader>zf", ":TZFocus<CR>", opt)
    end,
  },

  --------------
  --BEAUTIFING--
  --------------

  ----------------------
  --ACCELERATED-CODING--
  ----------------------
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end
  },
  {
    "rhysd/clever-f.vim"
  },
  {
    "rmagatti/goto-preview",
    config = function()
      require('goto-preview').setup {
        width = 120; -- Width of the floating window
        height = 25; -- Height of the floating window
        default_mappings = false; -- Bind default mappings
        debug = false; -- Print debug information
        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
        post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
        -- You can use "default_mappings = true" setup option
        -- Or explicitly set keybindings
        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
      }
    end
  },
  -------
  --Git--
  -------
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = {"fugitive"}
  }
}
-- vim.api.nvim_command('highlight LightBulbFloatWin ctermfg= ctermbg= guifg= guibg=')
-- vim.api.nvim_command('highlight LightBulbVirtualText ctermfg= ctermbg= guifg= guibg=')
------------
--MAPPINGS--
------------
-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

----

lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnosticss" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnosticss" },
}

lvim.builtin.which_key.mappings["ss"] = {
  name = "+Spectre",
  o = {"<cmd>lua require('spectre').open()<CR>", "Open spectre"},
  w = {"<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word"},
  v = {"lua require('spectre').open_visual()<CR>", "Search visual"}
}

lvim.builtin.which_key.mappings["b"] = {
  name = "+Buffer",
  l = {"<Cmd>Telescope buffers<CR>", "Telescope show buffers"},
  ck = {"<Cmd>BufferCloseBuffersRight<CR>", "Close buffers right"},
  cj = {"<Cmd>BufferCloseBuffersLeft<CR>", "Close buffers left"},
  cc = {"<Cmd>BufferClose!<CR>", "Close current buffer"},
  ec = {"<Cmd>BufferCloseAllButCurrent<CR>", "Buffers close all but current"},
  ep = {"<Cmd>BufferCloseAllButPinned<CR>", "Buffers close all but pinned"},
  p = {"<Cmd>BufferPick<CR>", "Buffer pick"},
  ol = {"<Cmd>BufferOrderByLanguage<CR>", "Buffer order by languge"},
  od = {"<Cmd>BufferOrderByDirectory<CR>", "Buffer order by directory"},
  on = {"<Cmd>BufferOrderByBufferNumber<CR>", "Buffer orfer by number"},
  bb = {"<Cmd>BufferPin<CR>", "Buffer pin"},
  w = {"<Cmd>BufferWipeout<CR>", "Buffer wipe out"}
}

lvim.builtin.which_key.mappings["f"] = {
  t = {"<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Current buffer fuzzy find"},
  f = {"<Cmd>Telescope find_files<CR>", "Find files"},
  g = {"<Cmd>Telescope live_grep<CR>", "Live grep"},
}

lvim.builtin.which_key.mappings["s"] = {
  name = "+Settings",
  cc = {"<Cmd>Telescope colorscheme<CR>", "Select colorscheme"},
  cp = {"<Cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<CR>", "Select colorscheme preview"}
}

lvim.keys.normal_mode["<leader>pd"] = false
lvim.keys.normal_mode["<leader>pi"] = false
lvim.keys.normal_mode["<leader>pc"] = false

lvim.keys.normal_mode = {
  ["<leader>pd"] = "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  ["<leader>pi"] = "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
  ["<leader>pc" ] = "<cmd>lua require('goto-preview').close_all_win()<CR>",
  -- ["<leader>lha"] = "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
  -- ["<leader>lhf"] = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>",
  -- ["<leader>lhd"] = "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
  -- ["<leader>lhr"] = "<cmd>lua require'lspsaga.rename'.rename()<CR>",

  ["<C-j>"] = "<cmd>wincmd j<CR>",
  ["<C-k>"] = "<cmd>wincmd k<CR>",
  ["<C-h>"] = "<cmd>wincmd h<CR>",
  ["<C-l>"] = "<cmd>wincmd l<CR>",

  ["<S-h>"] = ":BufferPrevious<CR>",
  ["<S-l>"] = ":BufferNext<CR>",
  ["<leader><"] = ":BufferMovePrevious<CR>",
  ["<leader>>"] = ":BufferMoveNext<CR>",
  ["<leader>1"] = ":BufferGoto 1<CR>",
  ["<leader>2"] = ":BufferGoto 2<CR>",
  ["<leader>3"] = ":BufferGoto 3<CR>",
  ["<leader>4"] = ":BufferGoto 4<CR>",
  ["<leader>5"] = ":BufferGoto 5<CR>",
  ["<leader>6"] = ":BufferGoto 6<CR>",
  ["<leader>7"] = ":BufferGoto 7<CR>",
  ["<leader>8"] = ":BufferGoto 8<CR>",
  ["<leader>9"] = ":BufferLast<CR>",

  ['<leader>bp'] = ':BufferPick<CR>',
  ['<Space>bb'] = ':BufferOrderByBufferNumber<CR>',
  ['<Space>bd'] = ':BufferOrderByDirectory<CR>',
  ['<Space>bl'] = ':BufferOrderByLanguage<CR>',

  ['<leader>ml'] = ':MarksListBuf<CR>',
  ['<leader>gg'] = "<Cmd>lua require('lvim.core.terminal')._exec_toggle('lazygit')<CR>",
  ['<leader>il'] =  "<cmd>Vista!!<CR>",
  ['<leader>id'] =  "<cmd>SymbolsOutline<CR>",

}

map("n", "<leader>m,", "<Plug>(Marks-setnext)", {noremap=false})
map("n", "<leader>m;", "<Plug>(Marks-toggle)", {noremap=false})
map("n", "<leader>dm<space>", "<Plug>(Marks-deletebuf)", {noremap=false})
map("n", "<leader>m:", "<Plug>(Marks-preview)", {noremap=false})
map("n", "<leader>m]", "<Plug>(Marks-next)", {noremap=false})
map("n", "<leader>m[", "<Plug>(Marks-prev)", {noremap=false})
map("n", "<leader>m[0-9]", "<Plug>(Marks-set-bookmark[0-9])", {noremap=false})
map("n", "<leader>dm[0-9]", "<Plug>(Marks-delete-bookmark[0-9])", {noremap=false})
map("n", "<leader>m}", "<Plug>(Marks-next-bookmark[0-9])", {noremap=false})
map("n", "<leader>m{", "<Plug>(Marks-pre-bookmark[0-9])", {noremap=false})

vim.g.splitjoin_join_mapping = ''
vim.g.splitjoin_split_mapping = ''
-- vim.api.nvim_set_keymap('n', 'sj', ':SplitjoinJoin<CR>', {})
-- vim.api.nvim_set_keymap('n', 'sk', ':SplitjoinSplit<CR>', {})

lvim.builtin.which_key.mappings["sj"] = {
  "<cmd>SplitjoinJoin<CR>", "Join"
}
lvim.builtin.which_key.mappings["sk"] = {
  "<cmd>SplitjoinSplit<CR>", "Split"
}

lvim.keys.visual_mode = {
  -- ["<leader>lha"] = "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>",
}


lvim.keys.insert_mode = {
  ["<C-j>"] = "<C-c>lbi",
  ["<C-k>"] = "<C-c>hei",
  ["<C-a>"] = "<C-c>A",
  ["<C-o>"] = "<C-c>A<Left>",
  -- ["<C-Enter>"] = "<C-c>o",
  -- ["<S-Enter>"] = "<C-c>O"
}

lvim.keys.normal_mode["<Esc>"] = ":nohlsearch<cr>"
vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})


vim.g.lazyredraw = true        --improve scrolling performance when navigating through large results
vim.g.regexpengine=1       --use old regexp engine
--set ignorecase smartcase  " ignore case only when the pattern contains no capital letters
vim.g.ignore = 'smartcase'
-- vim.g.far = {
--   source = 'rg',
--   window_width = 50,
--   preview_window_width = 50,
-- }
-- vim.api.nvim_set_var('prompt_mapping',
--     {
--       quit           = { key = '<esc>', prompt = 'Esc' },
--       regex          = { key = '<C-x>', prompt = '^X'  },
--       case_sensitive = { key = '<C-a>', prompt = '^A'  },
--       word           = { key = '<C-w>', prompt = "^W"  },
--       substitute     = { key = '<C-f>', prompt = '^F'  },
--     }
-- )
-- --shortcut for far.vim find
-- vim.api.nvim_set_keymap('n', '<localleader>f', ':Farf<cr>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('x', '<localleader>f', ':Farf<cr>', { noremap = true, silent = true })
-- -- shortcut for far.vim replace
-- vim.api.nvim_set_keymap('n', '<localleader>r', ':Farr<cr>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('x', '<localleader>r', ':Farr<cr>', { noremap = true, silent = true })

----------------------
--jpalardy/vim-slime--
----------------------
vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1
vim.g.slime_default_config = {
  socket_name= split(os.getenv('TMUX'), ',')[0],
  target_pane= '{top-right}'
}
vim.g.slime_dont_ask_default = 1
-- socket_name= "get(split($TMUX, ','), 0)",
-- target_pane= '{top-right}'

------------------------------
--hanschen/vim-ipython-cell--
------------------------------
map('n', '<leader>as', ':SlimeSend1 ipython --matplotlib<CR>', {noremap = true})
map('n', '<leader>ar', ':IPythonCellRun<CR>', {noremap = true})
map('n', '<leader>aR', ':IPythonCellRunTime<CR>', {noremap = true})
map('n', '<leader>ac', ':IPythonCellExecuteCell<CR>' )
map('n', '<leader>aC', ':IPythonCellExecuteCellJump<CR>', {noremap = true})
map('n', '<leader>ae', ':IPythonCellExecuteCellVerbose<CR>', {noremap = true})
map('n', '<leader>aE', ':IPythonCellExecuteCellVerboseJump<CR>', {noremap = true})
map('n', '<leader>al', ':IPythonCellClear<CR>', {noremap = true})
map('n', '<leader>ax', ':IPythonCellClose<CR>', {noremap = true})
map('n', '[c', ':IPythonCellPrevCell<CR>', {noremap = true})
map('n', ']c', ':IPythonCellNextCell<CR>', {noremap = true})
map('n', '<leader>ah', '<Plug>SlimeLineSend', {})
map('x', '<leader>ah', '<Plug>SlimeRegionSend', {})
map('n', '<leader>aj', '<Plug>SlimeParagraphSend', {})
map('n', '<leader>ap', ':IPythonCellPrevCommand<CR>', {noremap = true})
map('n', '<leader>aQ', ':IPythonCellRestart<CR>', {noremap = true})
map('n', '<leader>ad', ':SlimeSend1 %debug<CR>', {noremap = true})
map('n', '<leader>aq', ':SlimeSend1 exit<CR>', {noremap = true})
map('n', '<F2>', ':SlimeSend1 python % <CR>', {noremap = true})


---------------------
--simeji/winresizer--
---------------------
vim.g.winresizer_start_key="<Nop>"
map("n", "<C-e>r", ":WinResizerStartResize<CR>")
map("n", "<C-e>m", ":WinResizerStartMove<CR>")
map("n", "<C-e>f", ":WinResizerStartFocus<CR>")

lvim.autocommands.custom_groups = {
  { "WinLeave", "*", "set cursorline cursorcolumn" },
  { "WinEnter", "*", "set cursorline cursorcolumn" },
}
vim.cmd [[
hi CursorColumn cterm=bold ctermbg=red guibg=#464646
]]
-- map("n", miscMap.copywhole_file, ":%y+<CR>", opt)

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }


-- }

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
