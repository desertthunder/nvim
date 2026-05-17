local A = {}

A.sharp = {
  [[                                                                       ]],
  [[                                                                     ]],
  [[       ████ ██████           █████      ██                     ]],
  [[      ███████████             █████                             ]],
  [[      █████████ ███████████████████ ███   ███████████   ]],
  [[     █████████  ███    █████████████ █████ ██████████████   ]],
  [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
  [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
  [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
  [[                                                                       ]],
}

A.colossal = {
  [[                                                            ]],
  [[ 888b    888                  888     888 d8b               ]],
  [[ 8888b   888                  888     888 Y8P               ]],
  [[ 88888b  888                  888     888                   ]],
  [[ 888Y88b 888  .d88b.   .d88b. Y88b   d88P 888 88888b.d88b.  ]],
  [[ 888 Y88b888 d8P  Y8b d88""88b Y88b d88P  888 888 "888 "88b ]],
  [[ 888  Y88888 88888888 888  888  Y88o88P   888 888  888  888 ]],
  [[ 888   Y8888 Y8b.     Y88..88P   Y888P    888 888  888  888 ]],
  [[ 888    Y888  "Y8888   "Y88P"     Y8P     888 888  888  888 ]],
  [[
  ]],
}

A.delta = {
  [[                                                                   ]],
  [[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
  [[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
  [[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
  [[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
  [[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
  [[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
  [[                                                                   ]],
}

A.dos = {
  [[                                                                       ]],
  [[  ██████   █████                   █████   █████  ███                  ]],
  [[ ░░██████ ░░███                   ░░███   ░░███  ░░░                   ]],
  [[  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ]],
  [[  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ]],
  [[  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ]],
  [[  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ]],
  [[  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ]],
  [[ ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]],
  [[                                                                       ]],
}

local function hide_statusline(event)
  if vim.g.alpha_dashboard_laststatus == nil then vim.g.alpha_dashboard_laststatus = vim.o.laststatus end

  vim.o.laststatus = 0

  vim.api.nvim_create_autocmd('BufUnload', {
    buffer = event.buf,
    once = true,
    callback = function()
      local laststatus = vim.g.alpha_dashboard_laststatus
      if laststatus == nil then return end

      vim.o.laststatus = tonumber(laststatus) or 2
      vim.g.alpha_dashboard_laststatus = nil
    end,
  })
end

return {
  {
    'goolord/alpha-nvim',
    config = function()
      local dashboard = require 'alpha.themes.dashboard'

      dashboard.section.header.val = A.sharp
      dashboard.section.buttons.val = {
        dashboard.button('f', 'Find File', '<cmd>Telescope find_files<cr>'),
        dashboard.button('r', 'Recent Files', '<cmd>Telescope oldfiles<cr>'),
        dashboard.button('w', 'Find Word', '<cmd>Telescope live_grep<cr>'),
        dashboard.button('c', 'Config Files', '<cmd>Telescope find_files cwd=' .. vim.fn.stdpath 'config' .. '<cr>'),
        dashboard.button('n', 'New File', '<cmd>enew<cr>'),
        dashboard.button('q', 'Quit', '<cmd>qa<cr>'),
      }

      local ok, lazy = pcall(require, 'lazy')
      if ok then
        local stats = lazy.stats()
        dashboard.section.footer.val = 'Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. math.floor(stats.startuptime) .. ' ms'
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'alpha',
        callback = hide_statusline,
      })

      require('alpha').setup(dashboard.config)
    end,
  },
  { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {} },
  --#region Themes
  { 'folke/tokyonight.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'ptdewey/darkearth-nvim', lazy = true },
  {
    'ptdewey/vitesse-nvim',
    priority = 1000,
    config = function() vim.cmd.colorscheme 'vitesse' end,
  },
  {
    'sam4llis/nvim-tundra',
    lazy = true,
    init = function() vim.g.tundra_biome = vim.g.tundra_biome or 'arctic' end,
    opts = {
      plugins = {
        lsp = true,
        semantic_tokens = true,
        treesitter = true,
        telescope = true,
        gitsigns = true,
      },
    },
  },
  {
    'desertthunder/iced-lightning.nvim',
    config = function()
      require('iced-lightning').setup {
        transparent = false,
        terminal_colors = true,
        styles = { comments = { italic = true }, keywords = { italic = true } },
      }
    end,
  },
  --#endregion
  { 'NMAC427/guess-indent.nvim' },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- See `:help ibl`
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = { exclude = { filetypes = { 'alpha', 'dashboard' } } },
  },
  {
    -- Lua LSP for Neovim config, runtime and plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } },
  },
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = { css = true, css_fn = true },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        offsets = {
          { filetype = 'neo-tree', text = 'Neo-tree', highlight = 'Directory', text_align = 'left' },
        },
      },
    },
    keys = {
      { '<leader>bn', '<cmd>enew<cr>', desc = 'New Buffer' },
      { '<leader>bd', '<cmd>bdelete<cr>', desc = 'Delete Buffer' },
      { '<leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Toggle Pin' },
      { '<leader>bP', '<Cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete Buffers to the Left' },
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev Buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next Buffer' },
      { '[B', '<cmd>BufferLineMovePrev<cr>', desc = 'Move buffer prev' },
      { ']B', '<cmd>BufferLineMoveNext<cr>', desc = 'Move buffer next' },
    },
  },
  --#region Help UI
  {
    'desertthunder/cheatsheet.nvim',
    keys = { { '<leader>?', desc = 'Toggle [?] Cheatsheet' } },

    config = function()
      local cheatsheet = require 'cheatsheet'
      cheatsheet.setup {
        header = {
          '╭──────────────────────────────────────────────────────────────────────────────────────────────────────╮',
          '│                               ▗▄▄▖▗▖ ▗▖▗▄▄▄▖ ▗▄▖▗▄▄▄▖▗▄▄▖▗▖ ▗▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖                        │',
          '│                              ▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌ █ ▐▌   ▐▌ ▐▌▐▌   ▐▌     █                          │',
          '│                              ▐▌   ▐▛▀▜▌▐▛▀▀▘▐▛▀▜▌ █  ▝▀▚▖▐▛▀▜▌▐▛▀▀▘▐▛▀▀▘  █                          │',
          '│                              ▝▚▄▄▖▐▌ ▐▌▐▙▄▄▖▐▌ ▐▌ █ ▗▄▄▞▘▐▌ ▐▌▐▙▄▄▖▐▙▄▄▖  █                          │',
          '╰──────────────────────────────────────────────────────────────────────────────────────────────────────╯',
        },

        exclude_patterns = { '<Plug>', '<SNR>' },
        window = { width = 0.8, height = 0.8, border = 'rounded' },
      }

      vim.api.nvim_create_user_command('Cheatsheet', function() cheatsheet.toggle() end, { desc = 'Toggle cheatsheet window' })
      vim.keymap.set('n', '<leader>?', cheatsheet.toggle, { desc = 'Toggle [?] Cheatsheet' })
    end,
  },
  {
    -- Show pending keybinds
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  --#endregion
  --#region IDE Tooling
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
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
  },
  {
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
  },
  {
    -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = { lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 } },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
  {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function() require('conform').format { async = true, lsp_format = 'fallback' } end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return { timeout_ms = 500, lsp_format = 'fallback' }
        end
      end,
      formatters_by_ft = {
        go = { 'goimports', 'gofmt' },
        javascript = { 'dprint' },
        javascriptreact = { 'dprint' },
        lua = { 'stylua' },
        rust = { 'rustfmt' },
        typescript = { 'dprint' },
        typescriptreact = { 'dprint' },
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        markdown = { 'markdownlint-cli2' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then lint.try_lint() end
        end,
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions (based on mode
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function() return vim.fn.executable 'make' == 1 end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup { extensions = { ['ui-select'] = { require('telescope.themes').get_dropdown() } } }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set(
        'n',
        '<leader>/',
        function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end,
        { desc = '[/] Fuzzily search in current buffer' }
      )

      vim.keymap.set(
        'n',
        '<leader>s/',
        function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end,
        { desc = '[S]earch [/] in Open Files' }
      )

      vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  --#endregion
}
