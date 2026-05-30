--#region Package Management (vim-pack)
local function pack_info(name)
  for _, plug in ipairs(vim.pack.get()) do
    if plug.spec and plug.spec.name == name then return plug end
    if plug.name == name then return plug end
  end
end

local function pack_path(name)
  local plug = pack_info(name)
  return plug and (plug.path or plug.dir)
end

local function run_build(name, cmd)
  local path = pack_path(name)
  if not path then return end
  vim.system(cmd, { cwd = path }, function(res)
    if res.code ~= 0 then vim.schedule(function() vim.notify(('Build failed for %s: %s'):format(name, tostring(res.stderr)), vim.log.levels.ERROR) end) end
  end)
end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    elseif name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'make' })
    elseif name == 'LuaSnip' and vim.fn.executable 'make' == 1 and vim.fn.has 'win32' == 0 then
      run_build(name, { 'make', 'install_jsregexp' })
    end
  end,
})

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-neotest/nvim-nio',

  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/EdenEast/nightfox.nvim',
  'https://github.com/ptdewey/darkearth-nvim',
  'https://github.com/ptdewey/vitesse-nvim',
  'https://github.com/sam4llis/nvim-tundra',
  'https://github.com/desertthunder/iced-lightning.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/catgoose/nvim-colorizer.lua',
  'https://github.com/echasnovski/mini.nvim',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
  'https://github.com/desertthunder/cheatsheet.nvim',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range '2.x' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.x' },
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
}, { confirm = false })
--#endregion

require('nvim-autopairs').setup {}
vim.g.tundra_biome = vim.g.tundra_biome or 'arctic'
require('nvim-tundra').setup {
  plugins = {
    lsp = true,
    semantic_tokens = true,
    treesitter = true,
    telescope = true,
    gitsigns = true,
  },
}
require('iced-lightning').setup { transparent = false, terminal_colors = true, styles = { comments = { italic = true }, keywords = { italic = true } } }
vim.cmd.colorscheme 'vitesse'

require('guess-indent').setup {}
require('todo-comments').setup { signs = false }
require('ibl').setup { exclude = { filetypes = { 'dashboard' } } }
require('lazydev').setup { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } }
require('colorizer').setup { css = true, css_fn = true }

require('mini.ai').setup { n_lines = 500 }
require('mini.surround').setup()
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

--#region Buffer Management
local harpoon = require 'harpoon'
harpoon:setup {}

vim.keymap.set('n', '<leader>bn', '<cmd>enew<cr>', { desc = 'New Buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>ba', function() harpoon:list():add() end, { desc = 'Harpoon add buffer' })
vim.keymap.set('n', '<leader>bh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
vim.keymap.set('n', '<leader>bp', function() harpoon:list():prev() end, { desc = 'Harpoon previous' })
vim.keymap.set('n', '<leader>bl', function() harpoon:list():next() end, { desc = 'Harpoon next' })
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon buffer 1' })
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon buffer 2' })
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon buffer 3' })
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon buffer 4' })
vim.keymap.set('n', '<leader>5', function() harpoon:list():select(5) end, { desc = 'Harpoon buffer 5' })
vim.keymap.set('n', '<leader>6', function() harpoon:list():select(6) end, { desc = 'Harpoon buffer 6' })
vim.keymap.set('n', '<leader>7', function() harpoon:list():select(7) end, { desc = 'Harpoon buffer 7' })
vim.keymap.set('n', '<leader>8', function() harpoon:list():select(8) end, { desc = 'Harpoon buffer 8' })
vim.keymap.set('n', '<leader>9', function() harpoon:list():select(9) end, { desc = 'Harpoon buffer 9' })
vim.keymap.set('n', '<leader>0', function() harpoon:list():select(10) end, { desc = 'Harpoon buffer 10' })
vim.keymap.set('n', '<S-h>', function() harpoon:list():prev() end, { desc = 'Harpoon previous' })
vim.keymap.set('n', '<S-l>', function() harpoon:list():next() end, { desc = 'Harpoon next' })
vim.keymap.set('n', '[b', function() harpoon:list():prev() end, { desc = 'Harpoon previous' })
vim.keymap.set('n', ']b', function() harpoon:list():next() end, { desc = 'Harpoon next' })
--#endregion

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

require('which-key').setup {
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
}

--#region File Explorer (netrw)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1

local function toggle_netrw_sidebar()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'netrw' then
      vim.api.nvim_win_close(win, true)
      return
    end
  end

  local current_win = vim.api.nvim_get_current_win()
  local dir = vim.fn.expand '%:p:h'
  if dir == '' or vim.fn.isdirectory(dir) == 0 then dir = vim.fn.getcwd() end

  vim.cmd(('botright vertical %dnew'):format(vim.g.netrw_winsize))
  vim.wo.winfixwidth = true
  vim.cmd.Explore(vim.fn.fnameescape(dir))
  vim.api.nvim_set_current_win(current_win)
end

vim.keymap.set('n', '<leader>te', toggle_netrw_sidebar, { desc = 'Toggle netrw sidebar', silent = true })
vim.keymap.set('n', '\\', toggle_netrw_sidebar, { desc = 'Toggle netrw sidebar', silent = true })
--#endregion

local ts = require 'nvim-treesitter'
ts.setup { install_dir = vim.fn.stdpath 'data' .. '/site' }
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
vim.api.nvim_create_autocmd('FileType', { callback = function(args) pcall(vim.treesitter.start, args.buf) end })

require('blink.cmp').setup {
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
}
require('luasnip').setup {}

--#region Formatting and Linting
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500, lsp_format = 'fallback' }
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
}
vim.keymap.set('', '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

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
--#endregion

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end
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
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
  end,
}

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
  function() builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end,
  { desc = '[/] Fuzzily search in current buffer' }
)
vim.keymap.set(
  'n',
  '<leader>s/',
  function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
  { desc = '[S]earch [/] in Open Files' }
)
vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })

--#region LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
    map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, { bufnr = bufnr })
      end
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
    end
  end,
})

vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic) return diagnostic.message end,
  },
}

require('mason').setup {}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
  gopls = {},
  lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
  rust_analyzer = {},
  ts_ls = {},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'dprint',
  'eslint_d',
  'goimports',
  'markdownlint-cli2',
  'stylua',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}
--#endregion

--#region Debugging
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<F7>', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup { automatic_installation = true, handlers = {}, ensure_installed = {} }

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close
--#endregion
