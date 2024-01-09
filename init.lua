vim.g.airline_powerline_fonts = 1
require("neovim-config")
--print("hello")
require('lualine').setup()

-- Enable line numbering
vim.opt.nu = true

--colorscheme
vim.cmd("colorscheme kanagawa")
vim.cmd("lua colorMyPencils()")

