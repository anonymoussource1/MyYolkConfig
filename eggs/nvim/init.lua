vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.number = true
vim.o.undofile = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 1000
vim.o.splitbelow = true
vim.o.splitright = true
--vim.o.list = true
--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.wrap = false

vim.schedule(function ()
	vim.o.clipboard = 'unnamedplus'
end)

vim.keymap.set('n', '<Esc>', '<cmd>nohl<cr>', { desc = 'Clear highlighting' })
vim.keymap.set('n', 'tf', '<cmd>Ex<cr>', { desc = 'Go to file manager' })

-- Telescope
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescope.current_buffer_fuzzy_find, { desc = 'Telescope buffer fuzzy find' })
vim.keymap.set('n', '<leader>fh', telescope.help_tags, { desc = 'Telescope help tags' })

-- Undotree
vim.g.undotree_WindowLayout = 2
vim.keymap.set('n', '<leader>uu', '<cmd>UndotreeToggle<cr>', { desc = 'Open UndoTree' })

-- Diagnostic
vim.diagnostic.config({ virtual_lines = true })

-- LSP
-- Signature help	[x] C-S
-- Code Action		[x] gra
-- Document symbol	[x] grs
-- Definition		[x] grd, Use on variable
-- Implementation	[x] gri, Use on type
-- Hover			[x] grh
-- References		[x] grr
-- Rename 			[x] grn
-- Type definition	[x] grt, Use on variable
vim.api.nvim_create_autocmd('LspAttach', {
	desc = 'LSP actions',
	callback = function(event)
		vim.keymap.set('n', 'grh', vim.lsp.buf.hover, {buffer = event.buf})
		vim.keymap.set('n', 'grd', vim.lsp.buf.definition, {buffer = event.buf})
		vim.keymap.set('n', 'gO', '')
		vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, {buffer = event.buf})
		vim.keymap.set('n', 'grr', telescope.lsp_references, {buffer = event.buf})

		-- Fix issue where plugin overwrites value for rust files
		vim.o.expandtab = false

	end
})

vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if path ~= vim.fn.stdpath('config') and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					'${3rd}/luv/library'
					-- '${3rd}/busted/library'
				}
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

vim.lsp.config('rust_analyzer', {
	settings = {
		['rust-analyzer'] = {
			diagnostics = {
				enable = false;
			}
		}
	},
})

vim.lsp.enable({'lua_ls', 'rust_analyzer'})

-- Colorscheme
require('nightfox').setup({
	options = {
		transparent = false
	}
})
vim.cmd.colorscheme('nightfox')

require('render-markdown').setup({
	file_types = { "markdown", "Avante" },
})

-- Blink.cmp
require('blink.cmp').setup({
	keymap = { preset = 'default' },
	completion = {
		list = {
			selection = {
				auto_insert = false
			}
		},
		ghost_text = {
			enabled = true
		},
		menu = {
			auto_show = false
		},
		documentation = {
			auto_show = false,
		},
		keyword = {
			range = 'full'
		}
	},
	sources = { default = { 'lsp' } }
})

require('avante_lib').load()
require('avante').setup({
	provider = "claude",
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 60000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
      },
	},
	behaviour = {
		auto_suggestions = false,
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
	},
})

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
	desc = 'Save place in file',
	group = vim.api.nvim_create_augroup('save-place', { clear = true }),
	callback = function ()
		vim.cmd.normal({'g`"', bang = true})
	end
})
