local M = {}

-- Ported from sam4llis/nvim-tundra. Upstream organizes colors as "biomes";
-- each biome is a raw palette, then a stylesheet assigns those raw colors to
-- semantic roles such as editor foregrounds, syntax, diagnostics, diffs, and
-- git decorations. This local port keeps that shape so updates from upstream
-- remain easy to compare.
local palettes = {
  arctic = {
    white = '#ffffff',
    gray = {
      _50 = '#f9fafb',
      _200 = '#e5e7eb',
      _400 = '#9ca3af',
      _500 = '#6b7280',
      _600 = '#4b5563',
      _700 = '#374151',
      _750 = '#334155',
      _800 = '#1f2937',
      _900 = '#111827',
      _925 = '#111726',
      _950 = '#101624',
      _1000 = '#0e1420',
    },
    orange = '#fbc19d',
    red = {
      _400 = '#fecdd3',
      _500 = '#fca5a5',
      _800 = '#4c384c',
      _900 = '#3b2c3c',
    },
    indigo = {
      _400 = '#ddd6fe',
      _500 = '#a5b4fc',
      _800 = '#424674',
      _900 = '#28304d',
    },
    green = {
      _500 = '#b5e8b0',
      _600 = '#98bc99',
      _900 = '#1f343d',
    },
    sky = '#bae6fd',
  },
  jungle = {
    white = '#ffffff',
    gray = {
      _50 = '#e4e4e4',
      _200 = '#e5e7eb',
      _400 = '#a8a8a8',
      _500 = '#767676',
      _600 = '#545454',
      _700 = '#444444',
      _750 = '#343434',
      _800 = '#242424',
      _900 = '#1c1c1c',
      _925 = '#1a1a1a',
      _950 = '#181818',
      _1000 = '#141414',
    },
    orange = '#f5cfa9',
    red = {
      _400 = '#ffd7d7',
      _500 = '#ffafaf',
      _800 = '#362836',
      _900 = '#291f2a',
    },
    indigo = {
      _400 = '#d7d7ff',
      _500 = '#b5b5ff',
      _800 = '#303353',
      _900 = '#1c2237',
    },
    green = {
      _500 = '#afd7af',
      _600 = '#87af87',
      _900 = '#16252c',
    },
    sky = '#acd5fc',
  },
}

local function stylesheet(cp)
  -- Mirrors upstream `stylesheet/{arctic,jungle}.lua`: palette colors are not
  -- applied directly to highlight groups. They first become semantic buckets so
  -- editor chrome, syntax, diagnostics, and plugin integrations can share the
  -- same intended role across both biomes.
  return {
    fg = {
      normal = cp.gray._50,
      conceal = cp.gray._500,
      lnumber = cp.gray._600,
      statusline = cp.gray._200,
      whitespace = cp.gray._700,
    },
    bg = {
      normal = cp.gray._900,
      floating = cp.gray._1000,
      colorcolumn = cp.gray._800,
      cursorline = cp.gray._800,
      visual = cp.gray._700,
      dimmed = cp.gray._950,
      sidebar = cp.gray._925,
    },
    syntax = {
      comment = cp.gray._500,
      conditional = cp.red._400,
      constant = cp.orange,
      field = cp.indigo._400,
      func = cp.sky,
      identifier = cp.red._400,
      keyword = cp.red._500,
      number = cp.orange,
      operator = cp.red._400,
      preprocessor = cp.indigo._400,
      punctuation = cp.gray._400,
      regex = cp.red._500,
      string = cp.green._500,
      type = cp.red._400,
      variable = cp.gray._200,
      builtin_const = cp.orange,
      builtin_func = cp.orange,
      builtin_type = cp.red._500,
      builtin_var = cp.orange,
    },
    diagnostics = {
      error = cp.red._500,
      warning = cp.orange,
      information = cp.indigo._500,
      hint = cp.green._500,
      reference = cp.gray._750,
    },
    diff = {
      add = cp.green._900,
      change = cp.indigo._900,
      delete_fg = cp.red._800,
      delete_bg = cp.red._900,
      text = cp.indigo._800,
    },
    git = {
      added = cp.green._600,
      changed = cp.orange,
      removed = cp.red._500,
    },
  }
end

local function set(groups, name, opts)
  groups[name] = opts
end

local function build_groups(ss)
  local groups = {}

  -- Ported from sam4llis/nvim-tundra's editor highlight map. The `fg`,
  -- `bg`, `diagnostics`, `diff`, and `git` stylesheet buckets are preserved so
  -- Neovim UI groups use the same semantic roles as the original plugin.
  set(groups, 'Normal', { fg = ss.fg.normal, bg = ss.bg.normal })
  set(groups, 'NormalNC', { fg = ss.fg.normal, bg = ss.bg.normal })
  set(groups, 'NormalFloat', { fg = ss.fg.normal, bg = ss.bg.floating })
  set(groups, 'FloatBorder', { fg = ss.bg.cursorline, bg = ss.bg.floating })
  set(groups, 'FloatTitle', { fg = ss.syntax.keyword, bg = ss.bg.floating, bold = true })
  set(groups, 'Folded', { fg = ss.fg.conceal, bg = ss.bg.floating })
  set(groups, 'FoldColumn', { fg = ss.fg.conceal })
  set(groups, 'SignColumn', { fg = ss.fg.conceal, bg = ss.bg.normal })
  set(groups, 'Cursor', { fg = ss.bg.normal, bg = ss.fg.normal })
  set(groups, 'lCursor', { link = 'Cursor' })
  set(groups, 'CursorIM', { link = 'Cursor' })
  set(groups, 'CursorColumn', { link = 'CursorLine' })
  set(groups, 'CursorLine', { bg = ss.bg.cursorline })
  set(groups, 'ColorColumn', { bg = ss.bg.colorcolumn })
  set(groups, 'Conceal', { fg = ss.fg.conceal })
  set(groups, 'Visual', { bg = ss.bg.visual })
  set(groups, 'VisualNOS', { link = 'Visual' })
  set(groups, 'LineNr', { fg = ss.fg.lnumber })
  set(groups, 'CursorLineNr', { fg = ss.diagnostics.warning, bold = true })
  set(groups, 'Pmenu', { fg = ss.fg.normal, bg = ss.bg.floating })
  set(groups, 'PmenuSel', { bg = ss.bg.visual })
  set(groups, 'PmenuSbar', { link = 'Pmenu' })
  set(groups, 'PmenuThumb', { bg = ss.fg.whitespace })
  set(groups, 'Question', { link = 'MoreMsg' })
  set(groups, 'QuickFixLine', { link = 'CursorLine' })
  set(groups, 'Search', { fg = ss.bg.normal, bg = ss.diagnostics.information, bold = true })
  set(groups, 'IncSearch', { fg = ss.bg.normal, bg = ss.diagnostics.hint, bold = true })
  set(groups, 'CurSearch', { link = 'IncSearch' })
  set(groups, 'Substitute', { fg = ss.bg.normal, bg = ss.diagnostics.error, bold = true })
  set(groups, 'StatusLine', { fg = ss.fg.statusline, bg = ss.bg.normal })
  set(groups, 'StatusLineNC', { fg = ss.fg.normal, bg = ss.bg.normal })
  set(groups, 'TabLine', { fg = ss.fg.statusline, bg = ss.bg.normal })
  set(groups, 'TabLineFill', { bg = ss.bg.normal })
  set(groups, 'TabLineSel', { fg = ss.syntax.func, bg = ss.bg.cursorline })
  set(groups, 'WinBar', { fg = ss.fg.statusline, bg = ss.bg.normal, bold = true })
  set(groups, 'WinBarNC', { fg = ss.fg.statusline, bg = ss.bg.floating, bold = true })
  set(groups, 'SpellBad', { fg = ss.bg.normal, bg = ss.diagnostics.error, sp = ss.diagnostics.error, bold = true, undercurl = true })
  set(groups, 'SpellCap', { fg = ss.bg.normal, bg = ss.diagnostics.warning, sp = ss.diagnostics.warning, bold = true, undercurl = true })
  set(groups, 'SpellLocal', { fg = ss.bg.normal, bg = ss.diagnostics.information, sp = ss.diagnostics.information, bold = true, undercurl = true })
  set(groups, 'SpellRare', { fg = ss.bg.normal, bg = ss.diagnostics.information, sp = ss.diagnostics.information, bold = true, undercurl = true })
  set(groups, 'ErrorMsg', { fg = ss.diagnostics.error })
  set(groups, 'WarningMsg', { fg = ss.diagnostics.warning })
  set(groups, 'DiffAdd', { bg = ss.diff.add })
  set(groups, 'DiffChange', { bg = ss.diff.change })
  set(groups, 'DiffDelete', { fg = ss.diff.delete_fg, bg = ss.diff.delete_bg })
  set(groups, 'DiffText', { bg = ss.diff.text })
  set(groups, 'Directory', { fg = ss.syntax.func })
  set(groups, 'EndOfBuffer', { fg = ss.bg.normal })
  set(groups, 'MatchParen', { fg = ss.diagnostics.warning, bold = true })
  set(groups, 'ModeMsg', { fg = ss.diagnostics.warning, bold = true })
  set(groups, 'MoreMsg', { fg = ss.diagnostics.information, bold = true })
  set(groups, 'NonText', { fg = ss.bg.normal })
  set(groups, 'SpecialKey', { link = 'NonText' })
  set(groups, 'Title', { fg = ss.syntax.func })
  set(groups, 'Whitespace', { fg = ss.fg.whitespace })
  set(groups, 'WildMenu', { link = 'Pmenu' })
  set(groups, 'WinSeparator', { fg = ss.fg.conceal })
  set(groups, 'VertSplit', { link = 'WinSeparator' })

  -- These groups follow upstream `hl_group/syntax.lua`: Vim's legacy syntax
  -- names are mapped from the Tundra stylesheet's syntax bucket, with the same
  -- emphasis choices for comments, constants, numbers, operators, and types.
  set(groups, 'Boolean', { fg = ss.syntax.number, bold = true, italic = true })
  set(groups, 'Character', { link = 'String' })
  set(groups, 'Comment', { fg = ss.syntax.comment, bold = true, italic = true })
  set(groups, 'Conditional', { fg = ss.syntax.conditional })
  set(groups, 'Constant', { fg = ss.syntax.constant, bold = true })
  set(groups, 'Debug', { link = 'Special' })
  set(groups, 'Define', { link = 'PreProc' })
  set(groups, 'Delimiter', { fg = ss.syntax.punctuation })
  set(groups, 'Error', { fg = ss.diagnostics.error })
  set(groups, 'Exception', { link = 'Keyword' })
  set(groups, 'Float', { link = 'Number' })
  set(groups, 'Function', { fg = ss.syntax.func })
  set(groups, 'Identifier', { fg = ss.syntax.identifier })
  set(groups, 'Include', { link = 'PreProc' })
  set(groups, 'Keyword', { fg = ss.syntax.keyword })
  set(groups, 'Label', { link = 'Function' })
  set(groups, 'Macro', { link = 'PreProc' })
  set(groups, 'Number', { fg = ss.syntax.number, bold = true })
  set(groups, 'Operator', { fg = ss.syntax.operator, bold = true })
  set(groups, 'PreCondit', { link = 'PreProc' })
  set(groups, 'PreProc', { fg = ss.syntax.preprocessor })
  set(groups, 'Preproc', { link = 'PreProc' })
  set(groups, 'Repeat', { fg = ss.syntax.conditional })
  set(groups, 'Special', { fg = ss.syntax.func })
  set(groups, 'SpecialChar', { link = 'Special' })
  set(groups, 'SpecialComment', { link = 'Special' })
  set(groups, 'Statement', { fg = ss.syntax.keyword })
  set(groups, 'StorageClass', { link = 'Type' })
  set(groups, 'String', { fg = ss.syntax.string })
  set(groups, 'Structure', { link = 'Type' })
  set(groups, 'Tag', { link = 'Special' })
  set(groups, 'Todo', { fg = ss.diagnostics.information, bold = true })
  set(groups, 'Type', { fg = ss.syntax.type, italic = true })
  set(groups, 'Typedef', { link = 'Type' })

  set(groups, 'diffAdded', { fg = ss.git.added })
  set(groups, 'diffRemoved', { fg = ss.git.removed })
  set(groups, 'diffChanged', { fg = ss.git.changed })
  set(groups, 'diffOldFile', { fg = ss.diagnostics.warning })
  set(groups, 'diffNewFile', { fg = ss.diagnostics.hint })
  set(groups, 'diffFile', { fg = ss.diagnostics.information })
  set(groups, 'diffLine', { fg = ss.syntax.builtin_const })
  set(groups, 'diffIndexLine', { fg = ss.syntax.preprocessor })

  set(groups, 'DiagnosticError', { fg = ss.diagnostics.error, bold = true })
  set(groups, 'DiagnosticWarn', { fg = ss.diagnostics.warning, bold = true })
  set(groups, 'DiagnosticInfo', { fg = ss.diagnostics.information, bold = true })
  set(groups, 'DiagnosticHint', { fg = ss.diagnostics.hint, bold = true })
  set(groups, 'DiagnosticUnderlineError', { sp = ss.diagnostics.error, undercurl = true })
  set(groups, 'DiagnosticUnderlineWarn', { sp = ss.diagnostics.warning, undercurl = true })
  set(groups, 'DiagnosticUnderlineInfo', { sp = ss.diagnostics.information, undercurl = true })
  set(groups, 'DiagnosticUnderlineHint', { sp = ss.diagnostics.hint, undercurl = true })
  set(groups, 'LspReferenceText', { bg = ss.diagnostics.reference })
  set(groups, 'LspReferenceRead', { bg = ss.diagnostics.reference })
  set(groups, 'LspReferenceWrite', { bg = ss.diagnostics.reference })
  set(groups, 'LspCodeLens', { fg = ss.syntax.comment })
  set(groups, 'LspCodeLensSeparator', { fg = ss.bg.cursorline })
  set(groups, 'LspSignatureActiveParameter', { fg = ss.diagnostics.information })
  set(groups, 'LspInlayHint', { fg = ss.syntax.comment })

  -- Treesitter capture names changed over time. This port includes the original
  -- Tundra capture names and their modern aliases so current parsers and older
  -- grammars resolve to the same colors.
  set(groups, '@punctuation.delimiter', { link = 'Delimiter' })
  set(groups, '@punctuation.bracket', { link = 'Delimiter' })
  set(groups, '@punctuation.special', { link = 'Delimiter' })
  set(groups, '@punct.delimiter', { link = 'Delimiter' })
  set(groups, '@punct.bracket', { link = 'Delimiter' })
  set(groups, '@punct.special', { link = 'Delimiter' })
  set(groups, '@string', { link = 'String' })
  set(groups, '@string.regexp', { fg = ss.syntax.regex })
  set(groups, '@string.regex', { link = '@string.regexp' })
  set(groups, '@string.escape', { fg = ss.syntax.regex })
  set(groups, '@string.special', { link = 'String' })
  set(groups, '@character', { link = 'Character' })
  set(groups, '@character.special', { link = 'SpecialChar' })
  set(groups, '@boolean', { link = 'Boolean' })
  set(groups, '@number', { link = 'Number' })
  set(groups, '@float', { link = 'Float' })
  set(groups, '@function', { link = 'Function' })
  set(groups, '@function.call', { link = 'Function' })
  set(groups, '@function.builtin', { fg = ss.syntax.builtin_func })
  set(groups, '@function.macro', { fg = ss.syntax.builtin_func })
  set(groups, '@method', { link = 'Function' })
  set(groups, '@method.call', { link = 'Function' })
  set(groups, '@constructor', { link = 'Function' })
  set(groups, '@parameter', { fg = ss.syntax.field })
  set(groups, '@variable.parameter', { link = '@parameter' })
  set(groups, '@parameter.reference', { link = '@parameter' })
  set(groups, '@keyword', { link = 'Keyword' })
  set(groups, '@keyword.function', { link = 'Keyword' })
  set(groups, '@keyword.operator', { link = 'Operator' })
  set(groups, '@keyword.return', { link = 'Keyword' })
  set(groups, '@conditional', { link = 'Conditional' })
  set(groups, '@repeat', { link = 'Repeat' })
  set(groups, '@debug', { link = 'Debug' })
  set(groups, '@label', { link = 'Label' })
  set(groups, '@include', { link = 'Include' })
  set(groups, '@exception', { link = 'Exception' })
  set(groups, '@type', { link = 'Type' })
  set(groups, '@type.builtin', { fg = ss.syntax.builtin_type, italic = true })
  set(groups, '@type.qualifier', { link = 'Type' })
  set(groups, '@type.definition', { link = 'Type' })
  set(groups, '@storageclass', { link = 'StorageClass' })
  set(groups, '@attribute', { link = 'Constant' })
  set(groups, '@field', { fg = ss.syntax.field })
  set(groups, '@property', { link = '@field' })
  set(groups, '@variable', { fg = ss.syntax.variable })
  set(groups, '@variable.builtin', { fg = ss.syntax.builtin_var })
  set(groups, '@constant', { link = 'Constant' })
  set(groups, '@constant.builtin', { fg = ss.syntax.builtin_const, bold = true })
  set(groups, '@const.builtin', { link = '@constant.builtin' })
  set(groups, '@constant.macro', { link = 'Macro' })
  set(groups, '@const.macro', { link = '@constant.macro' })
  set(groups, '@module', { fg = ss.syntax.builtin_type })
  set(groups, '@namespace', { link = '@module' })
  set(groups, '@symbol', { link = 'Special' })
  set(groups, '@markup', { fg = ss.fg.normal })
  set(groups, '@text', { link = '@markup' })
  set(groups, '@markup.strong', { fg = ss.diagnostics.error })
  set(groups, '@text.strong', { link = '@markup.strong' })
  set(groups, '@markup.italic', { fg = ss.diagnostics.information, italic = true })
  set(groups, '@text.emphasis', { link = '@markup.italic' })
  set(groups, '@markup.underline', { underline = true })
  set(groups, '@text.underline', { link = '@markup.underline' })
  set(groups, '@markup.strikethrough', { strikethrough = true })
  set(groups, '@text.strike', { link = '@markup.strikethrough' })
  set(groups, '@markup.heading', { link = 'Keyword' })
  set(groups, '@text.title', { link = '@markup.heading' })
  set(groups, '@markup.raw', { link = 'String' })
  set(groups, '@text.literal', { link = '@markup.raw' })
  set(groups, '@markup.link.url', { fg = ss.syntax.identifier, underline = true })
  set(groups, '@text.uri', { link = '@markup.link.url' })
  set(groups, '@markup.math', { link = 'Special' })
  set(groups, '@text.math', { link = '@markup.math' })
  set(groups, '@markup.environment', { link = 'Macro' })
  set(groups, '@text.environment', { link = '@markup.environment' })
  set(groups, '@markup.environment.name', { link = 'Type' })
  set(groups, '@text.environment.name', { link = '@markup.environment.name' })
  set(groups, '@markup.link', { link = 'Constant' })
  set(groups, '@text.reference', { link = '@markup.link' })
  set(groups, '@comment', { link = 'Comment' })
  set(groups, '@define', { link = 'PreProc' })
  set(groups, '@error', { link = 'Error' })
  set(groups, '@operator', { link = 'Operator' })
  set(groups, '@preproc', { link = 'PreProc' })
  set(groups, '@tag', { fg = ss.syntax.keyword })
  set(groups, '@tag.attribute', { link = '@parameter' })
  set(groups, '@tag.delimiter', { link = 'Comment' })

  -- Plugin groups are adapted from upstream integration modules where this
  -- config has matching plugins. Unsupported integrations from nvim-tundra are
  -- intentionally left out rather than copied as unused highlight groups.
  set(groups, 'GitSignsAdd', { fg = ss.git.added })
  set(groups, 'GitSignsChange', { fg = ss.git.changed })
  set(groups, 'GitSignsDelete', { fg = ss.git.removed })
  set(groups, 'TelescopeMatching', { fg = ss.diagnostics.hint })
  set(groups, 'TelescopeSelection', { fg = ss.diagnostics.hint, bg = ss.bg.cursorline })
  set(groups, 'TelescopePromptTitle', { fg = ss.bg.floating, bg = ss.syntax.keyword, bold = true })
  set(groups, 'TelescopePromptPrefix', { fg = ss.diagnostics.hint })
  set(groups, 'TelescopePromptCounter', { fg = ss.diagnostics.hint })
  set(groups, 'TelescopePromptNormal', { bg = ss.bg.cursorline })
  set(groups, 'TelescopePromptBorder', { fg = ss.bg.cursorline, bg = ss.bg.cursorline })
  set(groups, 'TelescopeResultsTitle', { fg = ss.bg.floating, bg = ss.bg.floating, bold = true })
  set(groups, 'TelescopeResultsNormal', { bg = ss.bg.floating })
  set(groups, 'TelescopeResultsBorder', { fg = ss.bg.floating, bg = ss.bg.floating })
  set(groups, 'TelescopePreviewTitle', { fg = ss.bg.floating, bg = ss.syntax.string, bold = true })
  set(groups, 'TelescopePreviewNormal', { bg = ss.bg.floating })
  set(groups, 'TelescopePreviewBorder', { fg = ss.bg.floating, bg = ss.bg.floating })
  set(groups, 'NeoTreeNormal', { fg = ss.fg.normal, bg = ss.bg.sidebar })
  set(groups, 'NeoTreeNormalNC', { fg = ss.fg.normal, bg = ss.bg.sidebar })
  set(groups, 'NeoTreeDirectoryName', { fg = ss.syntax.func })
  set(groups, 'NeoTreeGitAdded', { fg = ss.git.added })
  set(groups, 'NeoTreeGitModified', { fg = ss.git.changed })
  set(groups, 'NeoTreeGitDeleted', { fg = ss.git.removed })
  set(groups, 'BufferLineFill', { bg = ss.bg.normal })
  set(groups, 'BufferLineBackground', { fg = ss.fg.statusline, bg = ss.bg.normal })
  set(groups, 'BufferLineBufferSelected', { fg = ss.fg.normal, bg = ss.bg.normal, bold = true })
  set(groups, 'BufferLineSeparator', { fg = ss.bg.normal, bg = ss.bg.normal })
  set(groups, 'MiniStatuslineModeNormal', { fg = ss.bg.normal, bg = ss.syntax.func, bold = true })
  set(groups, 'MiniStatuslineModeInsert', { fg = ss.bg.normal, bg = ss.diagnostics.hint, bold = true })
  set(groups, 'MiniStatuslineModeVisual', { fg = ss.bg.normal, bg = ss.syntax.field, bold = true })
  set(groups, 'MiniStatuslineModeReplace', { fg = ss.bg.normal, bg = ss.diagnostics.error, bold = true })
  set(groups, 'MiniStatuslineModeCommand', { fg = ss.bg.normal, bg = ss.diagnostics.warning, bold = true })
  set(groups, 'MiniStatuslineDevinfo', { fg = ss.fg.statusline, bg = ss.bg.floating })
  set(groups, 'MiniStatuslineFilename', { fg = ss.fg.normal, bg = ss.bg.floating })
  set(groups, 'MiniStatuslineFileinfo', { fg = ss.fg.statusline, bg = ss.bg.floating })
  set(groups, 'MiniStatuslineInactive', { fg = ss.fg.conceal, bg = ss.bg.normal })
  set(groups, 'BlinkCmpMenu', { fg = ss.fg.normal, bg = ss.bg.floating })
  set(groups, 'BlinkCmpMenuSelection', { fg = ss.diagnostics.hint, bg = ss.bg.cursorline })
  set(groups, 'BlinkCmpLabelMatch', { fg = ss.diagnostics.hint, bold = true })

  return groups
end

function M.setup(biome, colors_name)
  -- `:colorscheme tundra` follows upstream behavior by reading
  -- `vim.g.tundra_biome`, defaulting to `arctic`. Direct entry points such as
  -- `tundra-jungle` pass the biome explicitly.
  local name = biome or vim.g.tundra_biome or 'arctic'
  local cp = palettes[name]
  if not cp then error(('Unknown Tundra biome: %s'):format(name)) end

  vim.o.background = 'dark'
  vim.o.termguicolors = true
  vim.cmd.highlight 'clear'
  if vim.fn.exists 'syntax_on' == 1 then vim.cmd.syntax 'reset' end

  vim.g.colors_name = colors_name or (name == 'arctic' and 'tundra' or ('tundra-' .. name))
  vim.g.tundra_biome = name

  for group, opts in pairs(build_groups(stylesheet(cp))) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M
