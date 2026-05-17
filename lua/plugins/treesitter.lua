-- Highlight, edit, and navigate code
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {
    install_dir = vim.fn.stdpath 'data' .. '/site',
  },
  config = function(_, opts)
    local ts = require 'nvim-treesitter'
    ts.setup(opts)

    ts.install {
      'bash',
      'c',
      'diff',
      'go',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'rust',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
    }

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args) pcall(vim.treesitter.start, args.buf) end,
    })
  end,
}
