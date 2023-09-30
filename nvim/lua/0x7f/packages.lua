return require("lazy").setup({
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },

    {
        'nvim-telescope/telescope.nvim', tag = '0.1.3',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-context',

    'ThePrimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',

    {
        'NvChad/nvim-colorizer.lua',
        event = { 'User NvimStartupDone' },
        --config = function() require 'alex.ui.colorizer' end,
    },

    -- THEMES
    {'arcticicestudio/nord-vim', name = "nord"},
    {
        "daschw/leaf.nvim",
    },
    { 'rose-pine/neovim', name = 'rose-pine' },
    {
        'AlexvZyl/nordic.nvim',
        branch = 'dev',
        lazy = true,
        priority = 1001,
        config = function()
            require '0x7f.themes.nordic'
        end
    },
    --vim.cmd('colorscheme rose-pine')
    { "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function ()
            require '0x7f.themes.catppuccin'
        end
    },

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            {'williamboman/mason-lspconfig.nvim'}, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
}
)
