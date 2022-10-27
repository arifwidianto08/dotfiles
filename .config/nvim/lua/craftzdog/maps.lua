-- set leader key to space
vim.g.mapleader = " "
local opts = { noremap = true, silent = true }
local keymap = vim.keymap

keymap.set('n', 'x', '"_x')

-- Increment/decrement
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Delete a word backwards
keymap.set('n', 'dw', 'vb"_d')

-- Select all
keymap.set('n', '<C-a>', 'gg<S-v>G')

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- New tab
keymap.set('n', '<leader>te', ':tabedit')
keymap.set('n', '<leader>tb', ':tabnew<CR>')
keymap.set('n', '<leader>tx', ':tabclose<CR>')
keymap.set('n', '<leader>tn', ':tabn<CR>')
keymap.set('n', '<leader>tp', ':tabp<CR>')

-- Split window
keymap.set('n', '<leader>ss', '<C-w>s')
keymap.set('n', '<leader>sv', '<C-w>v')
keymap.set('n', '<leader>se', '<C-w>=')
keymap.set('n', '<leader>sx', ':close<CR>')
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- Open Explorer
keymap.set('n', '<leader>e', ':E<CR>')
keymap.set('n', '<leader>E', ':E<CR>')

-- Move window
keymap.set('n', '<Space>', '<C-w>w')
keymap.set('', '<leader>sh', '<C-w>h')
keymap.set('', '<leader>sk', '<C-w>k')
keymap.set('', '<leader>sj', '<C-w>j')
keymap.set('', '<leader>sl', '<C-w>l')

-- Resize window
keymap.set('n', '<C-w><left>', '<C-w><')
keymap.set('n', '<C-w><right>', '<C-w>>')
keymap.set('n', '<C-w><up>', '<C-w>+')
keymap.set('n', '<C-w><down>', '<C-w>-')

-- Insert --
-- Press jk fast to exit insert mode
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "kj", "<ESC>", opts)


-- Resize with arrows
keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Move text up and down
keymap.set("v", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("v", "<A-k>", ":m .-2<CR>==", opts)
keymap.set("v", "p", '"_dP', opts)
keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Save File
keymap.set("n", "<C-s>", ":w<CR><ESC>")
keymap.set("i", "<C-s>", "<ESC>:w<CR>a<ESC>")
keymap.set("n", "<Cmd-s>", ":w:<CR>")
keymap.set("i", "<Cmd-s>", "<ESC>:w<C")

-- Copy all
keymap.set("i", "<C-c>", "<cmd> %y+ <CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands (not on youtube nvim video)
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]
keymap.set("n", "<leader>rh", function() return function()
    require("gitsigns").reset_hunk()
  end
end
)
keymap.set("n", "<leader>ph", function() return function()
    require("gitsigns").preview_hunk()
  end
end
)
keymap.set("n", "<leader>gb", function() return function()
    require("gitsigns").blame_line()
  end
end
)
keymap.set("n", "<leader>td", function() return function()
    require("gitsigns").toggle_deleted()
  end
end
)


-- LSP
keymap.set("n", "<leader>gi", function() return function()
    vim.lsp.buf.implementation()
  end
end
)
keymap.set("n", "<leader>ls", function() return function()
    vim.lsp.buf.signature_help()
  end
end
)
keymap.set("n", "<leader>D", function() return function()
  end
end
)
