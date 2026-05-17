local M = {}

-- Ported from https://github.com/antfu/vscode-theme-vitesse. Each variant
-- keeps the upstream VS Code workbench colors (`editor.*`, `panel.*`,
-- `terminal.*`, `diffEditor.*`) and TextMate token colors (`tokenColors`) as
-- the source of truth, then renames them into a smaller palette used by Neovim
-- highlights.
local variants = {
  ['vitesse-dark'] = {
    background = 'dark',
    colors = {
      fg = '#dbd7ca',
      bg = '#121212',
      bg_alt = '#181818',
      bg_float = '#121212',
      border = '#191919',
      visual = '#343434',
      search = '#4a4124',
      inc_search = '#675a31',
      comment = '#758575',
      punctuation = '#666666',
      constant = '#c99076',
      entity = '#80a665',
      tag = '#4d9375',
      keyword = '#4d9375',
      storage = '#cb7676',
      string = '#c98a7d',
      support = '#b8a965',
      property = '#b8a965',
      variable = '#bd976a',
      type = '#5da994',
      namespace = '#db889a',
      class = '#6872ab',
      regexp = '#c4704f',
      number = '#4c9a91',
      red = '#cb7676',
      green = '#4d9375',
      yellow = '#e6cc77',
      blue = '#6394bf',
      magenta = '#d9739f',
      cyan = '#5eaab5',
      gray = '#666666',
      gray2 = '#bfbaaa',
      error = '#cb7676',
      warn = '#d4976c',
      info = '#6394bf',
      hint = '#4d9375',
      diff_add = '#1f3a2d',
      diff_delete = '#432828',
    },
  },
  ['vitesse-black'] = {
    background = 'dark',
    colors = {
      fg = '#dbd7ca',
      bg = '#000000',
      bg_alt = '#121212',
      bg_float = '#000000',
      border = '#191919',
      visual = '#2b2b2b',
      search = '#3b351e',
      inc_search = '#574d2a',
      comment = '#758575',
      punctuation = '#444444',
      constant = '#c99076',
      entity = '#80a665',
      tag = '#4d9375',
      keyword = '#4d9375',
      storage = '#cb7676',
      string = '#c98a7d',
      support = '#b8a965',
      property = '#b8a965',
      variable = '#bd976a',
      type = '#5da994',
      namespace = '#db889a',
      class = '#6872ab',
      regexp = '#c4704f',
      number = '#4c9a91',
      red = '#cb7676',
      green = '#4d9375',
      yellow = '#e6cc77',
      blue = '#6394bf',
      magenta = '#d9739f',
      cyan = '#5eaab5',
      gray = '#555555',
      gray2 = '#bfbaaa',
      error = '#cb7676',
      warn = '#d4976c',
      info = '#6394bf',
      hint = '#4d9375',
      diff_add = '#182b22',
      diff_delete = '#351f1f',
    },
  },
  ['vitesse-dark-soft'] = {
    background = 'dark',
    colors = {
      fg = '#dbd7ca',
      bg = '#222222',
      bg_alt = '#292929',
      bg_float = '#222222',
      border = '#252525',
      visual = '#3f3f3f',
      search = '#554a29',
      inc_search = '#706236',
      comment = '#758575',
      punctuation = '#666666',
      constant = '#c99076',
      entity = '#80a665',
      tag = '#4d9375',
      keyword = '#4d9375',
      storage = '#cb7676',
      string = '#c98a7d',
      support = '#b8a965',
      property = '#b8a965',
      variable = '#bd976a',
      type = '#5da994',
      namespace = '#db889a',
      class = '#6872ab',
      regexp = '#c4704f',
      number = '#4c9a91',
      red = '#cb7676',
      green = '#4d9375',
      yellow = '#e6cc77',
      blue = '#6394bf',
      magenta = '#d9739f',
      cyan = '#5eaab5',
      gray = '#737373',
      gray2 = '#bfbaaa',
      error = '#cb7676',
      warn = '#d4976c',
      info = '#6394bf',
      hint = '#4d9375',
      diff_add = '#294337',
      diff_delete = '#4e3333',
    },
  },
  ['vitesse-light'] = {
    background = 'light',
    colors = {
      fg = '#393a34',
      bg = '#ffffff',
      bg_alt = '#f7f7f7',
      bg_float = '#ffffff',
      border = '#f0f0f0',
      visual = '#dedede',
      search = '#f4e9b4',
      inc_search = '#eadb91',
      comment = '#a0ada0',
      punctuation = '#999999',
      constant = '#a65e2b',
      entity = '#59873a',
      tag = '#1e754f',
      keyword = '#1e754f',
      storage = '#ab5959',
      string = '#b56959',
      support = '#998418',
      property = '#998418',
      variable = '#b07d48',
      type = '#2e8f82',
      namespace = '#b05a78',
      class = '#5a6aa6',
      regexp = '#ab5e3f',
      number = '#2f798a',
      red = '#ab5959',
      green = '#1e754f',
      yellow = '#bda437',
      blue = '#296aa3',
      magenta = '#a13865',
      cyan = '#2993a3',
      gray = '#9c9d99',
      gray2 = '#4e4f47',
      error = '#ab5959',
      warn = '#a65e2b',
      info = '#296aa3',
      hint = '#1e754f',
      diff_add = '#dcefe4',
      diff_delete = '#f1d9d9',
    },
  },
  ['vitesse-light-soft'] = {
    background = 'light',
    colors = {
      fg = '#393a34',
      bg = '#f1f0e9',
      bg_alt = '#e7e5db',
      bg_float = '#f1f0e9',
      border = '#e7e5db',
      visual = '#d5d4cd',
      search = '#eadf9f',
      inc_search = '#dfcf78',
      comment = '#a0ada0',
      punctuation = '#999999',
      constant = '#a65e2b',
      entity = '#59873a',
      tag = '#1e754f',
      keyword = '#1e754f',
      storage = '#ab5959',
      string = '#b56959',
      support = '#998418',
      property = '#998418',
      variable = '#b07d48',
      type = '#2e8f82',
      namespace = '#b05a78',
      class = '#5a6aa6',
      regexp = '#ab5e3f',
      number = '#2f798a',
      red = '#ab5959',
      green = '#1e754f',
      yellow = '#bda437',
      blue = '#296aa3',
      magenta = '#a13865',
      cyan = '#2993a3',
      gray = '#979891',
      gray2 = '#4e4f47',
      error = '#ab5959',
      warn = '#a65e2b',
      info = '#296aa3',
      hint = '#1e754f',
      diff_add = '#d3e5d9',
      diff_delete = '#e9d0d0',
    },
  },
}

local function set(groups, name, opts)
  groups[name] = opts
end

local function build_groups(c)
  local groups = {}

  -- VS Code UI keys map cleanly to Neovim editor chrome:
  -- `editor.foreground/background` -> Normal, `editor.lineHighlightBackground`
  -- -> CursorLine, `panel.border` -> floating/split borders, and
  -- `editor.selectionBackground` / find-match keys -> Visual/Search groups.
  set(groups, 'Normal', { fg = c.fg, bg = c.bg })
  set(groups, 'NormalFloat', { fg = c.fg, bg = c.bg_float })
  set(groups, 'FloatBorder', { fg = c.border, bg = c.bg_float })
  set(groups, 'FloatTitle', { fg = c.keyword, bg = c.bg_float, bold = true })
  set(groups, 'ColorColumn', { bg = c.bg_alt })
  set(groups, 'CursorLine', { bg = c.bg_alt })
  set(groups, 'CursorLineNr', { fg = c.gray2, bold = true })
  set(groups, 'LineNr', { fg = c.gray })
  set(groups, 'SignColumn', { fg = c.gray, bg = c.bg })
  set(groups, 'FoldColumn', { fg = c.gray, bg = c.bg })
  set(groups, 'Folded', { fg = c.gray2, bg = c.bg_alt })
  set(groups, 'Visual', { bg = c.visual })
  set(groups, 'Search', { fg = c.fg, bg = c.search })
  set(groups, 'IncSearch', { fg = c.bg, bg = c.yellow })
  set(groups, 'CurSearch', { link = 'IncSearch' })
  set(groups, 'MatchParen', { fg = c.keyword, bg = c.bg_alt, bold = true })
  set(groups, 'NonText', { fg = c.border })
  set(groups, 'Whitespace', { fg = c.border })
  set(groups, 'SpecialKey', { fg = c.gray })
  set(groups, 'EndOfBuffer', { fg = c.bg })
  set(groups, 'Directory', { fg = c.keyword })
  set(groups, 'Title', { fg = c.keyword, bold = true })
  set(groups, 'Question', { fg = c.keyword })
  set(groups, 'MoreMsg', { fg = c.keyword })
  set(groups, 'ModeMsg', { fg = c.fg })
  set(groups, 'ErrorMsg', { fg = c.error })
  set(groups, 'WarningMsg', { fg = c.warn })
  set(groups, 'WinSeparator', { fg = c.border })
  set(groups, 'VertSplit', { link = 'WinSeparator' })
  set(groups, 'StatusLine', { fg = c.gray2, bg = c.bg })
  set(groups, 'StatusLineNC', { fg = c.gray, bg = c.bg })
  set(groups, 'TabLine', { fg = c.gray, bg = c.bg })
  set(groups, 'TabLineFill', { fg = c.gray, bg = c.bg })
  set(groups, 'TabLineSel', { fg = c.fg, bg = c.bg_alt })
  set(groups, 'Pmenu', { fg = c.fg, bg = c.bg_float })
  set(groups, 'PmenuSel', { fg = c.fg, bg = c.bg_alt })
  set(groups, 'PmenuSbar', { bg = c.bg_alt })
  set(groups, 'PmenuThumb', { bg = c.gray })
  set(groups, 'WildMenu', { fg = c.bg, bg = c.keyword })

  -- TextMate scopes from the VS Code theme drive the base syntax groups.
  -- Examples: `comment` -> Comment, `string` -> String,
  -- `constant.numeric` / `number` -> Number, `keyword` -> Keyword,
  -- `entity.name.function` -> Function, and punctuation scopes -> Delimiter.
  set(groups, 'Comment', { fg = c.comment, italic = true })
  set(groups, 'Constant', { fg = c.constant })
  set(groups, 'String', { fg = c.string })
  set(groups, 'Character', { fg = c.string })
  set(groups, 'Number', { fg = c.number })
  set(groups, 'Boolean', { fg = c.keyword })
  set(groups, 'Float', { fg = c.number })
  set(groups, 'Identifier', { fg = c.variable })
  set(groups, 'Function', { fg = c.entity })
  set(groups, 'Statement', { fg = c.keyword })
  set(groups, 'Conditional', { fg = c.keyword })
  set(groups, 'Repeat', { fg = c.keyword })
  set(groups, 'Label', { fg = c.keyword })
  set(groups, 'Operator', { fg = c.storage })
  set(groups, 'Keyword', { fg = c.keyword })
  set(groups, 'Exception', { fg = c.storage })
  set(groups, 'PreProc', { fg = c.storage })
  set(groups, 'Include', { fg = c.keyword })
  set(groups, 'Define', { fg = c.keyword })
  set(groups, 'Macro', { fg = c.constant })
  set(groups, 'PreCondit', { fg = c.keyword })
  set(groups, 'Type', { fg = c.type })
  set(groups, 'StorageClass', { fg = c.storage })
  set(groups, 'Structure', { fg = c.class })
  set(groups, 'Typedef', { fg = c.type })
  set(groups, 'Special', { fg = c.support })
  set(groups, 'SpecialChar', { fg = c.yellow })
  set(groups, 'Tag', { fg = c.tag })
  set(groups, 'Delimiter', { fg = c.punctuation })
  set(groups, 'Debug', { fg = c.red })
  set(groups, 'Underlined', { fg = c.keyword, underline = true })
  set(groups, 'Ignore', { fg = c.gray })
  set(groups, 'Error', { fg = c.error })
  set(groups, 'Todo', { fg = c.yellow, bg = c.bg_alt, bold = true })

  set(groups, 'DiagnosticError', { fg = c.error })
  set(groups, 'DiagnosticWarn', { fg = c.warn })
  set(groups, 'DiagnosticInfo', { fg = c.info })
  set(groups, 'DiagnosticHint', { fg = c.hint })
  set(groups, 'DiagnosticOk', { fg = c.green })
  set(groups, 'DiagnosticUnderlineError', { sp = c.error, undercurl = true })
  set(groups, 'DiagnosticUnderlineWarn', { sp = c.warn, undercurl = true })
  set(groups, 'DiagnosticUnderlineInfo', { sp = c.info, undercurl = true })
  set(groups, 'DiagnosticUnderlineHint', { sp = c.hint, undercurl = true })

  set(groups, 'DiffAdd', { bg = c.diff_add })
  set(groups, 'DiffChange', { bg = c.bg_alt })
  set(groups, 'DiffDelete', { fg = c.red, bg = c.diff_delete })
  set(groups, 'DiffText', { bg = c.visual })
  set(groups, 'Added', { fg = c.green })
  set(groups, 'Changed', { fg = c.blue })
  set(groups, 'Removed', { fg = c.red })

  -- Treesitter captures mirror the same TextMate intent rather than inventing
  -- a second palette. Captures such as `@property`, `@tag`, `@module`, and
  -- `@string.regexp` use the closest upstream TextMate or semantic-token color.
  set(groups, '@comment', { link = 'Comment' })
  set(groups, '@punctuation', { fg = c.punctuation })
  set(groups, '@punctuation.bracket', { fg = c.punctuation })
  set(groups, '@punctuation.delimiter', { fg = c.punctuation })
  set(groups, '@constant', { fg = c.constant })
  set(groups, '@constant.builtin', { fg = c.keyword })
  set(groups, '@constant.macro', { fg = c.constant })
  set(groups, '@string', { fg = c.string })
  set(groups, '@string.regexp', { fg = c.regexp })
  set(groups, '@string.escape', { fg = c.yellow })
  set(groups, '@character', { fg = c.string })
  set(groups, '@number', { fg = c.number })
  set(groups, '@boolean', { fg = c.keyword })
  set(groups, '@variable', { fg = c.variable })
  set(groups, '@variable.builtin', { fg = c.constant })
  set(groups, '@variable.parameter', { fg = c.fg })
  set(groups, '@property', { fg = c.property })
  set(groups, '@field', { link = '@property' })
  set(groups, '@function', { fg = c.entity })
  set(groups, '@function.builtin', { fg = c.support })
  set(groups, '@function.macro', { fg = c.constant })
  set(groups, '@method', { link = '@function' })
  set(groups, '@constructor', { fg = c.type })
  set(groups, '@keyword', { fg = c.keyword })
  set(groups, '@keyword.function', { fg = c.keyword })
  set(groups, '@keyword.operator', { fg = c.storage })
  set(groups, '@keyword.return', { fg = c.keyword })
  set(groups, '@operator', { fg = c.storage })
  set(groups, '@type', { fg = c.type })
  set(groups, '@type.builtin', { fg = c.storage })
  set(groups, '@type.definition', { fg = c.class })
  set(groups, '@module', { fg = c.namespace })
  set(groups, '@namespace', { fg = c.namespace })
  set(groups, '@tag', { fg = c.tag })
  set(groups, '@tag.attribute', { fg = c.variable })
  set(groups, '@tag.delimiter', { fg = c.punctuation })
  set(groups, '@markup.heading', { fg = c.keyword, bold = true })
  set(groups, '@markup.link', { fg = c.string, underline = true })
  set(groups, '@markup.raw', { fg = c.keyword })
  set(groups, '@markup.quote', { fg = c.type })
  set(groups, '@markup.italic', { fg = c.fg, italic = true })
  set(groups, '@markup.strong', { fg = c.fg, bold = true })

  -- Plugin groups reuse the corresponding Neovim roles so integrations stay
  -- visually aligned with the original VS Code surfaces: git decorations,
  -- sidebars, pickers, completion menus, buffers, and status lines.
  set(groups, 'GitSignsAdd', { fg = c.green })
  set(groups, 'GitSignsChange', { fg = c.blue })
  set(groups, 'GitSignsDelete', { fg = c.red })
  set(groups, 'NeoTreeNormal', { fg = c.fg, bg = c.bg })
  set(groups, 'NeoTreeNormalNC', { fg = c.fg, bg = c.bg })
  set(groups, 'NeoTreeDirectoryName', { fg = c.keyword })
  set(groups, 'NeoTreeGitAdded', { fg = c.green })
  set(groups, 'NeoTreeGitModified', { fg = c.blue })
  set(groups, 'NeoTreeGitDeleted', { fg = c.red })
  set(groups, 'TelescopeNormal', { fg = c.fg, bg = c.bg_float })
  set(groups, 'TelescopeBorder', { fg = c.border, bg = c.bg_float })
  set(groups, 'TelescopeSelection', { fg = c.fg, bg = c.bg_alt })
  set(groups, 'TelescopeMatching', { fg = c.keyword, bold = true })
  set(groups, 'BufferLineFill', { fg = c.gray, bg = c.bg })
  set(groups, 'BufferLineBackground', { fg = c.gray, bg = c.bg })
  set(groups, 'BufferLineBufferSelected', { fg = c.fg, bg = c.bg, bold = true })
  set(groups, 'BufferLineSeparator', { fg = c.border, bg = c.bg })
  set(groups, 'MiniStatuslineModeNormal', { fg = c.bg, bg = c.keyword, bold = true })
  set(groups, 'MiniStatuslineModeInsert', { fg = c.bg, bg = c.green, bold = true })
  set(groups, 'MiniStatuslineModeVisual', { fg = c.bg, bg = c.magenta, bold = true })
  set(groups, 'MiniStatuslineModeReplace', { fg = c.bg, bg = c.red, bold = true })
  set(groups, 'MiniStatuslineModeCommand', { fg = c.bg, bg = c.yellow, bold = true })
  set(groups, 'MiniStatuslineDevinfo', { fg = c.gray2, bg = c.bg_alt })
  set(groups, 'MiniStatuslineFilename', { fg = c.fg, bg = c.bg_alt })
  set(groups, 'MiniStatuslineFileinfo', { fg = c.gray2, bg = c.bg_alt })
  set(groups, 'MiniStatuslineInactive', { fg = c.gray, bg = c.bg })
  set(groups, 'BlinkCmpMenu', { fg = c.fg, bg = c.bg_float })
  set(groups, 'BlinkCmpMenuSelection', { fg = c.fg, bg = c.bg_alt })
  set(groups, 'BlinkCmpLabelMatch', { fg = c.keyword, bold = true })

  return groups
end

function M.setup(name)
  local variant = variants[name]
  if not variant then error(('Unknown Vitesse variant: %s'):format(name)) end

  vim.o.termguicolors = true
  vim.cmd.highlight 'clear'
  if vim.fn.exists 'syntax_on' == 1 then vim.cmd.syntax 'reset' end

  vim.g.colors_name = name
  vim.o.background = variant.background

  -- The source VS Code themes use alpha channels for selections and diffs.
  -- Neovim highlight groups need concrete RGB colors, so this port keeps the
  -- same hue relationships with pre-blended values per variant.
  for group, opts in pairs(build_groups(variant.colors)) do
    vim.api.nvim_set_hl(0, group, opts)
  end

  vim.g.terminal_color_0 = variant.colors.bg
  vim.g.terminal_color_1 = variant.colors.red
  vim.g.terminal_color_2 = variant.colors.green
  vim.g.terminal_color_3 = variant.colors.yellow
  vim.g.terminal_color_4 = variant.colors.blue
  vim.g.terminal_color_5 = variant.colors.magenta
  vim.g.terminal_color_6 = variant.colors.cyan
  vim.g.terminal_color_7 = variant.colors.fg
  vim.g.terminal_color_8 = variant.colors.gray
  vim.g.terminal_color_9 = variant.colors.red
  vim.g.terminal_color_10 = variant.colors.green
  vim.g.terminal_color_11 = variant.colors.yellow
  vim.g.terminal_color_12 = variant.colors.blue
  vim.g.terminal_color_13 = variant.colors.magenta
  vim.g.terminal_color_14 = variant.colors.cyan
  vim.g.terminal_color_15 = '#ffffff'
end

return M
