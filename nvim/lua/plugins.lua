return {
    'tpope/vim-surround',
    {
      'wplohrmann/treewalker.nvim',
      commit = 'f012a564947443ded7f5275b0159966ed742f468',
      opts = {
          normalize = false,
          wow = true,
      }
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
