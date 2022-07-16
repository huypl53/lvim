-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

opt = {}

function split(inputstr, sep)
	local t = {}
	if inputstr == nil or inputstr == "" then
		t[0] = ""
		return t
	end
	if sep == nil then
		sep = "%s"
	end
	local i = 0
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedarker"

lvim.leader = "space"
lvim.localleader = ";"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

vim.opt.relativenumber = true
vim.opt.ignorecase = true
-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.mode = "startify"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.show_icons.git = 0
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.update_cwd = false

require("nvim-tree").setup({
	view = {
		mappings = {
			list = {
				{ key = "<C-s>", action = "split" },
			},
		},
	},
})
lvim.builtin.project.manual_mode = true

lvim.transparent_window = true
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
	"tsx",
}

-- Beautify
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

local components = require("lvim.core.lualine.components")
components.filename.path = 1
lvim.builtin.lualine.sections.lualine_b = {
	components.branch,
	components.filename,
}

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
lvim.lsp.on_attach_callback = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { noremap = true, silent = true }

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.

	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
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
-- local function goto_definition(split_cmd)
-- 	local util = vim.lsp.util
-- 	local log = require("vim.lsp.log")
-- 	local api = vim.api

-- 	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
-- 	local handler = function(_, result, ctx)
-- 		if result == nil or vim.tbl_isempty(result) then
-- 			local _ = log.info() and log.info(ctx.method, "No location found")
-- 			return nil
-- 		end

-- 		if split_cmd then
-- 			vim.cmd(split_cmd)
-- 		end

-- 		if vim.tbl_islist(result) then
-- 			util.jump_to_location(result[1])

-- 			if #result > 1 then
-- 				util.setqflist(util.locations_to_items(result))
-- 				api.nvim_command("copen")
-- 				api.nvim_command("wincmd p")
-- 			end
-- 		else
-- 			util.jump_to_location(result)
-- 		end
-- 	end

-- 	return handler
-- end
-- vim.lsp.handlers["textDocument/definition"] = goto_definition("split")

require("lspconfig")["html"].setup({
	filetypes = { "html", "hbs" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
		provideFormatter = true,
	},
	settings = {},
	single_file_support = true,
})
-- $ npm install -g emmet-ls
-- vim.list_extend(lvim.lsp.override, { "emmet_ls" })
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig")["emmet_ls"].setup({
	on_attach = lvim.lsp.on_attach_callback,
	capabilities = capabilities,
	filetypes = { "html", "css", "typescriptreact", "javascriptreact" },
})

require("lspconfig")["eslint"].setup({
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	on_new_config = function(config, new_root_dir)
		-- The "workspaceFolder" is a VSCode concept. It limits how far the
		-- server will traverse the file system when locating the ESLint config
		-- file (e.g., .eslintrc).
		config.settings.workspaceFolder = {
			uri = new_root_dir,
			name = vim.fn.fnamemodify(new_root_dir, ":t"),
		}
	end,
	settings = {
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		nodePath = "",
		onIgnoredFiles = "off",
		packageManager = "npm",
		quiet = false,
		rulesCustomizations = {},
		run = "onType",
		useESLintClass = false,
		validate = "on",
		workingDirectory = {
			mode = "location",
		},
	},
})

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	-- {
	-- 	exe = "clang_format",
	-- 	filetypes = { "c", "cpp" },
	-- },
	{
		exe = "prettierd",
		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
	},
	{
		exe = "black",
		filetypes = { "python" },
	},
	{
		exe = "isort",
		filetypes = { "python" },
	},
	{
		-- $ cargo install stylua$
		exe = "stylua",
		filetypes = { "lua" },
		args = { "-s", "-" },
	},
})

-- local linters = require("lvim.lsp.null-ls.linters")
-- linters.setup({
-- 	{
-- 		exe = "eslint_d",
-- 		filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
-- 	},
-- })

----------------------------
-- Disable default plugins--
----------------------------
lvim.builtin.bufferline.active = false
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
		config = function()
			require("lsp_signature").on_attach()
		end,
		event = "InsertEnter",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
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
		end,
	},
	{
		"alvan/vim-closetag",
	},
	{
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("todo-comments").setup({
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
				},
			})
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		after = {
			"nvim-treesitter",
			"plenary.nvim",
		},
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("refactoring").setup()
		end,
	},
	{
		"romgrk/barbar.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			vim.cmd([[
      let bufferline = get(g:, 'bufferline', {})
      let bufferline.icon_separator_active = ''
      let bufferline.icon_separator_inactive = ''
      ]])
		end,
	},
	-----------------
	--Coding helper--
	-----------------
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			require("bqf").setup({
				auto_enable = true,
				preview = {
					win_height = 12,
					win_vheight = 12,
					delay_syntax = 80,
					border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
				},
				func_map = {
					vsplit = "",
					ptogglemode = "z,",
					stoggleup = "",
				},
				filter = {
					fzf = {
						action_for = { ["ctrl-s"] = "split" },
						extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
					},
				},
			})
			vim.cmd("hi BqfPreviewBorder guifg=#50a14f ctermfg=71")
			vim.cmd("hi link BqfPreviewRange Search")
			vim.cmd("hi default link BqfPreviewFloat Normal")
			vim.cmd("hi default link BqfPreviewBorder Normal")
			vim.cmd("hi default link BqfPreviewCursor Cursor")
			vim.cmd("hi default link BqfPreviewRange IncSearch")
			vim.cmd("hi default BqfSign ctermfg=14 guifg=Cyan")
		end,
	},

	{
		"tweekmonster/startuptime.vim",
		cmd = "StartupTime",
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
			vim.g.indent_blankline_char_highlight_list = {
				"Underlined",
				"Method",
				"Type",
				"Float",
				"Conditional",
				"String",
				"Debug",

				"Method",
				"Type",
				"Float",
				"Conditional",
				"String",
				"Debug",
				-- "SpecialComment"
			}
			vim.g.indent_blankline_show_current_context = true
			vim.g.indent_blankline_show_current_start = true
			vim.cmd("highlight IndentBlanklineContextStart guisp=#00FF00 gui=underline")
		end,
	},

	------------
	-- Jumping--
	------------
	{
		"rhysd/accelerated-jk",
	},
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "<leader>hc", ":HopChar1<CR>", { silent = true })
			-- vim.api.nvim_set_keymap("n", "<leader>hc", ":HopChar2<CR>", { silent = true })
			vim.api.nvim_set_keymap("n", "<leader>hw", ":HopWord<CR>", { silent = true })
		end,
	},
	{
		"simeji/winresizer",
		config = function()
			vim.g.winresizer_start_key = "<Nop>"
			map("n", "<C-e>r", ":WinResizerStartResize<CR>")
			map("n", "<C-e>m", ":WinResizerStartMove<CR>")
			map("n", "<C-e>f", ":WinResizerStartFocus<CR>")
		end,
	},

	{
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()

			lvim.builtin.telescope.on_config_done = function(telescope)
        local actions = require("telescope.actions")
        local trouble = require("trouble.providers.telescope")
				telescope.setup({
					defaults = {
						mappings = {
							i = { ["<c-t>"] = trouble.open_with_trouble },
							n = { ["<c-t>"] = trouble.open_with_trouble },
						},
					},
				})
			end
			require("trouble").setup({})
		end,
	},

	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		after = "trouble.nvim",
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	},

	{
		"junegunn/Limelight.vim",
		cmd = "Limelight",
	},
	{
		"luochen1990/rainbow",
		ft = {
			"html",
			"css",
			"javascript",
			"javascriptreact",
			"go",
			"python",
			"lua",
			"rust",
			"vim",
			"less",
			"stylus",
			"sass",
			"scss",
			"json",
			"ruby",
			"toml",
		},
	},
	{
		"ap/vim-css-color",
	},
	{
		"dstein64/nvim-scrollview",
		config = function()
			vim.cmd("hi ScrollView ctermbg=159 guibg=LightCyan")
		end,
	},
	{
		"tpope/vim-surround",
	},
	-- {
	--   "tribela/vim-transparent"
	-- },
	{
		"chentoast/marks.nvim",
		event = "BufEnter",
		config = function()
			require("marks").setup({
				default_mappings = true,
				builtin_marks = { ".", "<", ">", "^" },
				cyclic = true,
				force_write_shada = false,
				refresh_interval = 150,
				sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
				bookmark_0 = {
					sign = "⚑",
					virt_text = "hello world",
				},
				mappings = {
					-- preview = "m:",
					-- set_next = "m,",
				},
			})
		end,
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
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				filter_kind = {
					"Class",
					"Constructor",
					"Enum",
					"Function",
					"Interface",
					"Module",
					"Method",
					"Struct",
					"Variable",
					"Namespace",
					"TypeParameter",
					"Package",
					"Constant",
					"Object",
				},
				backends = {
					js = { "lsp" },
				},
			})
		end,
	},
	{
		"liuchengxu/vista.vim",
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			vim.g.symbols_outline = {
				auto_preview = false,
				width = 18,
			}
		end,
	},
	{
		"AndrewRadev/splitjoin.vim",
	},
	{
		"jpalardy/vim-slime",
		ft = { "python", "javascript" },
	},
	{
		"hanschen/vim-ipython-cell",
		ft = { "python", "javascript" },
		requires = { "jpalardy/vim-slime" },
	},
	{
		"kkoomen/vim-doge",
		ft = { "python" },
		config = function()
			vim.g.doge_doc_standard_python = "numpy"
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown", "pandoc.markdown", "rmd", "adoc" },
		run = "cd app && npm install",
		cmd = "MarkdownPreview",
		config = function()
			vim.g.mkdp_echo_preview_url = 1
		end,
	},

	------------
	--foramter--
	------------
	{
		"sbdchd/neoformat",
		cmd = "Neoformat",
	},
	{
		"mhartington/formatter.nvim",
	},

	-- -- TODO: install neuron in docker
	-- neovim 0.6.0 not supported
	-- {
	--   "oberblastmeister/neuron.nvim",
	--   requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope.nvim" } },
	--   config = function ()
	--   -- these are all the default values
	--   require'neuron'.setup {
	--       virtual_titles = true,
	--       mappings = true,
	--       run = nil, -- function to run when in neuron dir
	--       neuron_dir = "~/neuron", -- the directory of all of your notes, expanded by default (currently supports only one directory for notes, find a way to detect neuron.dhall to use any directory)
	--       leader = "gz", -- the leader key to for all mappings, remember with 'go zettel'
	--   }
	--   end
	-- },
	{
		"Chiel92/vim-autoformat",
		config = function()
			vim.g.python3_host_prog = "/bin/python3"
			vim.g.formatterpath = "$HOME/.local/bin/black"
		end,
	},
	-- {
	-- 	"dense-analysis/ale",
	-- 	after = "nvim-lspconfig",
	-- 	config = function()
	-- 		vim.g.ale_echo_msg_error_str = "E"
	-- 		vim.g.ale_echo_msg_warning_str = "W"
	-- 		vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
	-- 		vim.g.ale_completion_enabled = 0
	-- 		vim.g.ale_lint_on_text_changed = "never"
	-- 		vim.g.ale_lint_on_enter = 0
	-- 		vim.g.ale_sign_error = " "
	-- 		vim.g.ale_sign_warning = " "
	-- 		vim.cmd([[
	--        highlight clear ALEErrorSign
	--        highlight clear ALEWarningSign
	--      ]])
	-- 	end,
	-- },
	{
		"t9md/vim-choosewin",
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>-", "<Plug>(choosewin)", opt)
			vim.g.choosewin_overlay_enable = 1
		end,
	},
	{
		"Pocco81/TrueZen.nvim",
		config = function()
			require("true-zen").setup({
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
			})
		end,
		setup = function()
			map("n", "<leader>vtz", ":TZAtaraxis<CR>", opt)
			map("n", "<leader>vtm", ":TZMinimalist<CR>", opt)
			map("n", "<leader>vtf", ":TZFocus<CR>", opt)
		end,
	},

	--------------
	--BEAUTIFING--
	--------------
	{
		"prettier/vim-prettier",
		run = "yarn install --frozen-lockfile --production",
		ft = {
			"javascript",
			"typescript",
			"css",
			"less",
			"scss",
			"graphql",
			"markdown",
			"vue",
			"html",
		},
	},
	----------------------
	--ACCELERATED-CODING--
	----------------------
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup()
			vim.g.better_escape_interval = 0
		end,
	},
	{
		"rhysd/clever-f.vim",
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
			"Gedit",
		},
		ft = { "fugitive" },
	},

	--Session--
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		module = "persistence",
		config = function()
			require("persistence").setup({
				-- dir = vim.fn.expand(vim.fn.stdpath("config") .. "/sessions/"), -- directory where session files are saved
				dir = ".cache/sessions/", -- directory where session files are saved
				options = { "buffers", "curdir", "tabpages", "winsize" }, -- sessionoptions used for saving
			})
		end,
	},
	-----------
	--Web dev--
	{
		"tzachar/cmp-tabnine",
		ft = { "js", "ts", "py", "vue", "jsx", "tsx" },
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
		config = function()
			require("cmp").setup({
				sources = {
					{ name = "cmp_tabnine" },
				},
			})
		end,
	},
	{
		"jose-elias-alvarez/nvim-lsp-ts-utils",
		config = function()
			require("lspconfig")["tsserver"].setup({
				init_options = require("nvim-lsp-ts-utils").init_options,
				on_attach = function(client, bufnr)
					local ts_utils = require("nvim-lsp-ts-utils")
					ts_utils.setup({
						debug = false,
						disable_commands = false,
						enable_import_on_completion = false,

						import_all_timeout = 5000, -- ms
						import_all_priorities = {
							same_file = 1, -- add to existing import statement
							local_files = 2, -- git files or files with relative path markers
							buffer_content = 3, -- loaded buffer content
							buffers = 4, -- loaded buffer names
						},
						import_all_scan_buffers = 100,
						import_all_select_source = false,
						always_organize_imports = true,
						filter_out_diagnostics_by_severity = {},
						filter_out_diagnostics_by_code = {},
						auto_inlay_hints = true,
						inlay_hints_highlight = "Comment",
						inlay_hints_priority = 200, -- priority of the hint extmarks
						inlay_hints_throttle = 150, -- throttle the inlay hint request
						inlay_hints_format = { -- format options for individual hint kind
							Type = {},
							Parameter = {},
							Enum = {},
						},

						update_imports_on_move = false,
						require_confirmation_on_move = false,
						watch_dir = nil,
					})
					ts_utils.setup_client(client)
					local opts = { silent = true }
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", ":TSLspRenameFile<CR>", opts)
				end,
			})
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.diagnostics.eslint, -- eslint or eslint_d
					null_ls.builtins.code_actions.eslint, -- eslint or eslint_d
					null_ls.builtins.formatting.prettier, -- prettier, eslint, eslint_d, or prettierd
				},
			})
		end,
	},
	-------------
	--Formatter--
	{
		"andrejlevkovitch/vim-lua-format",
	},
}
-- Global variables

-- vim.api.nvim_command('highlight LightBulbFloatWin ctermfg= ctermbg= guifg= guibg=')
-- vim.api.nvim_command('highlight LightBulbVirtualText ctermfg= ctermbg= guifg= guibg=')
------------
--MAPPINGS--
------------
-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

----

lvim.keys.normal_mode["<leader>pd"] = false
lvim.keys.normal_mode["<leader>pi"] = false
lvim.keys.normal_mode["<leader>pc"] = false
lvim.keys.normal_mode["<leader>q"] = false

lvim.builtin.which_key.mappings["t"] = {
	name = "+Trouble",
	r = { "<cmd>Trouble lsp_references<cr>", "References" },
	f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
	d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnosticss" },
	q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
	l = { "<cmd>Trouble loclist<cr>", "LocationList" },
	w = { "<cmd>Trouble workspace_diagnostics<cr>", "Diagnosticss" },
}

lvim.builtin.which_key.mappings["q"] = {
	name = "Persistence",
	s = { '<cmd>lua require("persistence").load()<cr>', "restore the session for the current directory" },
	l = { '<cmd>lua require("persistence").load({ last = true })<cr>', "restore the last session" },
	d = { '<cmd>lua require("persistence").stop()<cr>', "stop Persistence => session won't be saved on exit" },
}

lvim.builtin.which_key.mappings["ss"] = {
	name = "+Spectre",
	o = { "<cmd>lua require('spectre').open()<CR>", "Open spectre" },
	w = { "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", "Search current word" },
	v = { "lua require('spectre').open_visual()<CR>", "Search visual" },
}

lvim.builtin.which_key.mappings["b"] = {
	name = "+Buffer",
	l = { "<Cmd>Telescope buffers<CR>", "Telescope show buffers" },
	ck = { "<Cmd>BufferCloseBuffersRight<CR>", "Close buffers right" },
	cj = { "<Cmd>BufferCloseBuffersLeft<CR>", "Close buffers left" },
	cc = { "<Cmd>BufferClose<CR>", "Close current buffer" },
	p = { "<Cmd>BufferPick<CR>", "Buffer pick" },
	ol = { "<Cmd>BufferOrderByLanguage<CR>", "Buffer order by languge" },
	od = { "<Cmd>BufferOrderByDirectory<CR>", "Buffer order by directory" },
	on = { "<Cmd>BufferOrderByBufferNumber<CR>", "Buffer orfer by number" },
}

lvim.builtin.which_key.mappings["f"] = {
	t = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Current buffer fuzzy find" },
	f = { "<Cmd>Telescope find_files<CR>", "Find files" },
	g = { "<Cmd>Telescope live_grep<CR>", "Live grep" },
	a = { "<Cmd>Telescope live_grep_args<CR>", "Live grep args" },
}

lvim.builtin.which_key.mappings["s"] = {
	name = "+Settings",
	cc = { "<Cmd>Telescope colorscheme<CR>", "Select colorscheme" },
	cp = {
		"<Cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<CR>",
		"Select colorscheme preview",
	},
}

lvim.builtin.which_key.mappings["v"] = {
	name = "+View",
	fi = { "<cmd> set fdm=indent<CR>", "Set fdm to indent" },
	fm = { "<cmd> set fdm=manual<CR>", "Set fdm to manual" },
	fe = { "<cmd> set fdm=expr<CR>", "Set fdm to expression" },
	fs = { "<cmd> set fdm fdl<CR>", "Show fold status" },
}

vim.g.splitjoin_join_mapping = ""
vim.g.splitjoin_split_mapping = ""

lvim.keys.normal_mode = {
	-- ["<leader>pd"] = "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
	-- ["<leader>pi"] = "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
	-- ["<leader>pc"] = "<cmd>lua require('goto-preview').close_all_win()<CR>",
	-- ["<leader>lha"] = "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
	-- ["<leader>lhf"] = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>",
	-- ["<leader>lhd"] = "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
	-- ["<leader>lhr"] = "<cmd>lua require'lspsaga.rename'.rename()<CR>",

	["<C-j>"] = "<cmd>wincmd j<CR>",
	["<C-k>"] = "<cmd>wincmd k<CR>",
	["<C-h>"] = "<cmd>wincmd h<CR>",
	["<C-l>"] = "<cmd>wincmd l<CR>",

	["<S-l>"] = ":BufferNext<CR>",
	["<S-h>"] = ":BufferPrevious<CR>",
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

	["<leader>ml"] = ":MarksListBuf<CR>",
	["<leader>m,"] = "<Plug>(Marks-setnext)",
	["<leader>m;"] = "<Plug>(Marks-toggle)",
	["<leader>dm<space>"] = "<Plug>(Marks-deletebuf)",
	["<leader>m:"] = "<Plug>(Marks-preview)",
	["<leader>m]"] = "<Plug>(Marks-next)",
	["<leader>m["] = "<Plug>(Marks-prev)",
	["<leader>m[0-9]"] = "<Plug>(Marks-set-bookmark[0-9])",
	["<leader>dm[0-9]"] = "<Plug>(Marks-delete-bookmark[0-9])",
	["<leader>m}"] = "<Plug>(Marks-next-bookmark[0-9])",
	["<leader>m{"] = "<Plug>(Marks-pre-bookmark[0-9])",
	["<leader>gg"] = "<Cmd>lua require('lvim.core.terminal')._exec_toggle('lazygit')<CR>",
	["<leader>il"] = "<cmd>Vista!!<CR>",
	["<leader>id"] = "<cmd>SymbolsOutline<CR>",
	["<leader>ia"] = "<cmd>AerialToggle!<CR>",

	["<leader>rf"] = "<cmd>RnvimrToggle<CR>",

	["sj"] = ":SplitjoinJoin<CR>",
	["ss"] = ":SplitjoinSplit<CR>",
}

-- lvim.keys.visual_mode = {
-- ["<leader>lha"] = "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>",
-- }

lvim.keys.insert_mode = {
	["<C-j>"] = "<C-c>lbi",
	["<C-k>"] = "<C-c>hea",
	["<C-e>"] = "<C-c>A",
	["<C-o>"] = "<C-c>A<Left>",
	["<C-l>"] = "<C-c>o",
	["<M-b>"] = "<C-c>F{a",
}

lvim.keys.normal_mode["<Esc>"] = ":nohlsearch<cr>"
vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})

vim.g.lazyredraw = true --improve scrolling performance when navigating through large results
vim.g.regexpengine = 1 --use old regexp engine

----------------------
--jpalardy/vim-slime--
----------------------
vim.g.slime_target = "tmux"
vim.g.slime_python_ipython = 1
vim.g.slime_default_config = {
	socket_name = split(os.getenv("TMUX"), ",")[0],
	target_pane = "{top-right}",
}
vim.g.slime_dont_ask_default = 1
-- socket_name= "get(split($TMUX, ','), 0)",
-- target_pane= '{top-right}'

------------------------------
--hanschen/vim-ipython-cell--
------------------------------
map("n", "<leader>as", ":SlimeSend1 ipython --matplotlib<CR>", { noremap = true })
map("n", "<leader>ar", ":IPythonCellRun<CR>", { noremap = true })
map("n", "<leader>aR", ":IPythonCellRunTime<CR>", { noremap = true })
map("n", "<leader>ac", ":IPythonCellExecuteCell<CR>")
map("n", "<leader>aC", ":IPythonCellExecuteCellJump<CR>", { noremap = true })
map("n", "<leader>ae", ":IPythonCellExecuteCellVerbose<CR>", { noremap = true })
map("n", "<leader>aE", ":IPythonCellExecuteCellVerboseJump<CR>", { noremap = true })
map("n", "<leader>al", ":IPythonCellClear<CR>", { noremap = true })
map("n", "<leader>ax", ":IPythonCellClose<CR>", { noremap = true })
map("n", "[c", ":IPythonCellPrevCell<CR>", { noremap = true })
map("n", "]c", ":IPythonCellNextCell<CR>", { noremap = true })
map("n", "<leader>ah", "<Plug>SlimeLineSend", {})
map("x", "<leader>ah", "<Plug>SlimeRegionSend", {})
map("n", "<leader>aj", "<Plug>SlimeParagraphSend", {})
map("n", "<leader>ap", ":IPythonCellPrevCommand<CR>", { noremap = true })
map("n", "<leader>aQ", ":IPythonCellRestart<CR>", { noremap = true })
map("n", "<leader>ad", ":SlimeSend1 %debug<CR>", { noremap = true })
map("n", "<leader>aq", ":SlimeSend1 exit<CR>", { noremap = true })
map("n", "<F2>", ":SlimeSend1 python % <CR>", { noremap = true })

---------------------
--simeji/winresizer--
---------------------
vim.g.winresizer_start_key = "<Nop>"
map("n", "<C-e>r", ":WinResizerStartResize<CR>")
map("n", "<C-e>m", ":WinResizerStartMove<CR>")
map("n", "<C-e>f", ":WinResizerStartFocus<CR>")

--     cmd "hi Visual guibg=#336600 gui=bold"

vim.fn.Format_sync_sel_first = function(options, timeout_ms)
	function format(client)
		if client == nil then
			return
		end
		local params = vim.lsp.util.make_formatting_params(options)
		local bufnr = vim.api.nvim_get_current_buf()
		local result, err = client.request_sync("textDocument/formatting", params, timeout_ms, bufnr)
		if result and result.result then
			vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
		elseif err then
			vim.notify("vim.lsp.buf.formatting_sync: " .. err, vim.log.levels.WARN)
		end
	end

	vim.validate({
		on_choice = { format, "function", false },
	})
	local clients = vim.tbl_values(vim.lsp.buf_get_clients())

	clients = vim.tbl_filter(function(client)
		return client.supports_method("textDocument/formatting")
	end, clients)

	table.sort(clients, function(a, b)
		return a.name < b.name
	end)

	if #clients > 0 then
		format(clients[1])
	end
end

lvim.autocommands.custom_groups = {
	{ "VimEnter", "*", "set fdm=indent fdl=1" },
	{ "VimEnter", "*", "hi SignColumn guibg=none" },

	{ "WinNew", "*", "setlocal cursorline cursorcolumn" },
	{ "WinNew", "*", "hi CursorColumn guibg=#443960 gui=bold" },
	{ "WinNew", "*", "hi CursorLine guibg=#443960 gui=bold,underline" },

	{ "WinEnter", "*", "setlocal cursorline cursorcolumn" },
	{ "WinEnter", "*", "hi CursorColumn guibg=#443960 gui=bold" },
	{ "WinEnter", "*", "hi CursorLine guibg=#443960 gui=bold,underline" },

	{ "WinLeave", "*", "setlocal nocursorline nocursorcolumn" },
	{ "WinLeave", "*", "hi CursorColumn guibg=None gui=None" },
	{ "WinLeave", "*", "hi CursorLine guibg=None gui=None,underline" },

	-- { "BufRead", "*.jsx", "set filetype=javascript" },
	{ "BufWritePre", "*.js,*.jsx,*.ts,*.tsx", "lua vim.fn.Format_sync_sel_first()" },
}

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
