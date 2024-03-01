vim.g.airline_powerline_fonts = 1
require("neovim-config")

--For debugging
	--print("hello")

--For calling LuaLine
require('lualine').setup()



-- Enable line numbering
vim.opt.nu = true

-- Relative Line number
vim.opt.relativenumber = true

--colorscheme // Disabled for now
--vim.cmd("colorscheme kanagawa")
--vim.cmd("lua colorMyPencils()")

