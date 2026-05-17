return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>te', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>tg', ':Neotree git_status<CR>', desc = 'NeoTree git status', silent = true },
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    enable_git_status = true,
    sources = { 'filesystem', 'git_status' },
    source_selector = {
      winbar = true,
      statusline = false,
      sources = { { source = 'filesystem' }, { source = 'git_status' } },
    },
    filesystem = { window = { mappings = { ['\\'] = 'close_window' } } },
  },
}
