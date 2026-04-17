return {
    'tpope/vim-surround',
    {
      'aaronik/treewalker.nvim',
      opts = {}
    },
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- optional but recommended
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        }
    },
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      opts = {
        modes = {
         search = {
           enabled = true,
          },
          char = {
            enabled = false,
          },
        },
      },
      keys = {},
    },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate'
    },
    { 'nvim-mini/mini.nvim', version = false }
}
