----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Neovim Basics


-- Calling the Neovim Config Folder
--require("neovim-config")

-- Enable line numbering
vim.opt.nu = true

-- Relative Line number
vim.opt.relativenumber = true

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Lazy Nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Plugins

local plugins = {
	-- Kanagawa Colour Scheme
	{"rebelot/kanagawa.nvim", name = kanagawa, priority = 1000},

	-- Lua Line
	{'nvim-lualine/lualine.nvim',dependencies = {'nvim-tree/nvim-web-devicons'}},

	-- Telescope
	{'nvim-telescope/telescope.nvim', tag = '0.1.5',dependencies = { 'nvim-lua/plenary.nvim'}},

	-- Tree Sitter
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

	-- LSP Zero
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'hrsh7th/cmp-nvim-lsp'},
	{'hrsh7th/nvim-cmp'},
	{'L3MON4D3/LuaSnip'},
	-- for :MasonUpdateAll
	{'RubixDev/mason-update-all'},

	-- for dap
	--{'jayp0521/mason-nvim-dap.nvim'},
	-- dapui
	--{ "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },



	--Vim Be good
	{'ThePrimeagen/vim-be-good'},

	-- Markdown Preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	}

}


-- Options
local opts = {};

-- Loading Mason and Lazy
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins, opts) -- Lazy
require("mason").setup() -- Mason
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Remaps

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv",vim.cmd.Ex)

-- For Copying to Clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Disabling mouse
--vim.opt.mouse = ""
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Colour Scheme


function colorMyPencils(color)
	color = color or "kanagawa-dragon"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", {bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none" })

end

colorMyPencils()
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- LSP Zero Config
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'lua_ls', 'clangd', 'cmake'},
  handlers = {
    lsp_zero.default_setup,
    lua_ls = function()
      local lua_opts = lsp_zero.nvim_lua_ls()
      require('lspconfig').lua_ls.setup(lua_opts)
      require('lspconfig').clangd.setup{} -- C/C++
      require('lspconfig').cmake.setup{} -- Cmake
      require('lspconfig').marksman.setup{} -- Markdown and others
      require('lspconfig').html.setup{} -- html
      require('lspconfig').pyright.setup{} -- html
      
      


    end,
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
  formatting = lsp_zero.cmp_format(),
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Enter>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})


----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Lua Line Config

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'jellybeans',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Telescope Config


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>pws', function()
	local word = vim.fn.expand("<cword>")
	builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>pWs', function()
	local word = vim.fn.expand("<cWORD>")
	builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Tree sitter Config


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim","cpp", "html", "python"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  --ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled

    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

----------------------------------------------------------------------------
----------------------------------------------------------------------------
