---@class ODashButton
---@field txt string|fun(): string Dashboard label.
---@field icon? string Nerd Font icon rendered before `txt`.
---@field keys? string Buffer-local key that runs `cmd`.
---@field cmd? string Ex command without `<cmd>`/`<cr>` wrappers.
---@field hl? string Highlight group used for the button label.
---@field no_gap? boolean Do not add a blank line after this item.
---@field rep? boolean Repeat `txt` to fill the current content width.
---@field content? 'fit' Use this item's width rather than the widest dashboard width.
---@field group? string Align this item with other items in the same group.
---@field multicolumn? boolean Render this entry as multiple virtual-text chunks.
---@field pad? integer|'full' Space inserted after a multicolumn chunk.

---@class ODashConfig
---@field load_on_startup boolean Open ODash on `VimEnter` when Neovim starts without file arguments.
---@field art string|string[]|fun(): string[] Art name from `custom.odash.art`, explicit lines, or a line factory.
---@field buttons ODashButton[]|fun(): ODashButton[] Dashboard entries.

---ODash is a local dashboard port based on NvChad's nvdash module.
---
---Credits: this implementation is adapted from `nvchad/ui` v3.0's
---`lua/nvchad/nvdash/init.lua`, with config/runtime dependencies replaced by
---local ODash settings for this Neovim configuration.
---@see https://github.com/NvChad/ui/tree/v3.0/lua/nvchad/nvdash
local M = {}

local api = vim.api
local strw = api.nvim_strwidth

---@type ODashConfig
local defaults = {
  load_on_startup = true,
  art = 'sharp',
  buttons = {
    { icon = '', txt = 'Find File', keys = 'f', cmd = 'Telescope find_files', group = 'actions' },
    { icon = '', txt = 'Recent Files', keys = 'r', cmd = 'Telescope oldfiles', group = 'actions' },
    { icon = '󰈭', txt = 'Find Word', keys = 'w', cmd = 'Telescope live_grep', group = 'actions' },
    { icon = '', txt = 'Config Files', keys = 'c', cmd = 'Telescope find_files cwd=' .. vim.fn.stdpath('config'), group = 'actions' },
    { icon = '', txt = 'New File', keys = 'n', cmd = 'enew', group = 'actions' },
    { icon = '󰗼', txt = 'Quit', keys = 'q', cmd = 'qa', group = 'actions' },
    { txt = '─', hl = 'ODashFooter', no_gap = true, rep = true, group = 'footer' },
    {
      txt = function()
        local ok, lazy = pcall(require, 'lazy')
        if not ok then return 'ODash' end

        local stats = lazy.stats()
        local ms = math.floor(stats.startuptime) .. ' ms'
        return 'Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms
      end,
      icon = '',
      hl = 'ODashFooter',
      no_gap = true,
      content = 'fit',
      group = 'footer',
    },
    { txt = '─', hl = 'ODashFooter', no_gap = true, rep = true, group = 'footer' },
  },
}

---@type ODashConfig
local opts = vim.deepcopy(defaults)

---@param keys string[]
---@param action string|function
---@param buf integer
local function map(keys, action, buf)
  for _, key in ipairs(keys) do
    vim.keymap.set('n', key, action, { buffer = buf, nowait = true, silent = true })
  end
end

---@param txt1 string
---@param txt2 string
---@param max_str_w integer
---@return string
local function button_text(txt1, txt2, max_str_w)
  local btn_len = strw(txt1) + #txt2
  local spacing = math.max(max_str_w - btn_len, 1)
  return txt1 .. string.rep(' ', spacing) .. txt2
end

---@param item ODashButton
---@return string
local function button_txt(item)
  return type(item.txt) == 'string' and item.txt or item.txt()
end

---@param item ODashButton
---@return string
local function icon_prefix(item)
  return item.icon and (item.icon .. '  ') or ''
end

---@param item ODashButton
---@param width integer
---@return table
local function button_virt_text(item, width)
  local prefix = icon_prefix(item)
  local content_width = width - strw(prefix)
  local txt = button_txt(item)

  if item.rep then
    return { { string.rep(txt, width), item.hl or 'ODashButton' } }
  end

  if item.keys then
    txt = button_text(txt, item.keys, content_width)
  end

  local virt_text = {}
  if prefix ~= '' then
    table.insert(virt_text, { prefix, 'ODashIcon' })
  end

  table.insert(virt_text, { txt, item.hl or 'ODashButton' })
  return virt_text
end

---@param tb ODashButton[]
---@param buf? integer
---@return integer
local function multicolumn_width(tb, buf)
  local pad = tb.pad or 0
  local width = 0 - pad

  for _, item in ipairs(tb) do
    pad = item.pad and item.pad ~= 'full' and item.pad or pad
    width = width + strw(item.txt --[[@as string]]) + pad

    if buf and item.keys and item.cmd then
      map({ item.keys }, '<cmd>' .. item.cmd .. '<cr>', buf)
    end
  end

  return width
end

---@param tb ODashButton[]
---@param total_w integer
---@param virt_w integer
---@return table
local function multicolumn_virt_texts(tb, total_w, virt_w)
  local line = {}

  for _, item in ipairs(tb) do
    local txt = type(item.txt) == 'string' and item.txt or item.txt()
    table.insert(line, { txt, item.hl })

    local pad = item.pad == 'full' and total_w - virt_w or item.pad
    table.insert(line, { string.rep(' ', pad or tb.pad or 0) })
  end

  return line
end

---@return string[]
local function get_art()
  if type(opts.art) == 'function' then return opts.art() end
  if type(opts.art) == 'table' then return opts.art end

  local art = require 'custom.odash.art'
  return art[opts.art] or art.sharp
end

---@return ODashButton[]
local function get_buttons()
  return type(opts.buttons) == 'function' and opts.buttons() or opts.buttons
end

---@param buf integer
local function set_clean_buffer_options(buf)
  vim.api.nvim_set_option_value('buflisted', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'odash', { buf = buf })
  vim.api.nvim_set_option_value('number', false, { scope = 'local' })
  vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local' })
  vim.api.nvim_set_option_value('cursorline', false, { scope = 'local' })
  vim.api.nvim_set_option_value('colorcolumn', '0', { scope = 'local' })
  vim.api.nvim_set_option_value('foldcolumn', '0', { scope = 'local' })
  vim.api.nvim_set_option_value('list', false, { scope = 'local' })
  vim.api.nvim_set_option_value('wrap', false, { scope = 'local' })
end

local function set_highlights()
  vim.api.nvim_set_hl(0, 'ODashAscii', { link = 'Type', default = true })
  vim.api.nvim_set_hl(0, 'ODashIcon', { link = 'Special', default = true })
  vim.api.nvim_set_hl(0, 'ODashButton', { link = 'Function', default = true })
  vim.api.nvim_set_hl(0, 'ODashFooter', { link = 'Comment', default = true })
end

local function hide_statusline()
  if vim.g.odash_laststatus == nil then
    vim.g.odash_laststatus = vim.o.laststatus
  end

  vim.o.laststatus = 0
end

local function restore_statusline()
  local laststatus = vim.g.odash_laststatus
  if laststatus == nil then return end

  vim.o.laststatus = tonumber(laststatus) or 2
  vim.g.odash_laststatus = nil
end

---@param buf? integer
---@param win? integer
---@param action? 'open'|'redraw'
function M.open(buf, win, action)
  action = action or 'open'
  win = win or api.nvim_get_current_win()

  local ns = api.nvim_create_namespace 'odash'
  local winh = api.nvim_win_get_height(win)
  local winw = api.nvim_win_get_width(win)

  buf = buf or api.nvim_create_buf(false, true)
  vim.g.odash_buf = buf
  vim.g.odash_win = win

  if action == 'open' then
    api.nvim_win_set_buf(win, buf)
    hide_statusline()
  end

  local dashboard_w = 0
  local ui = {}

  for _, line in ipairs(get_art()) do
    dashboard_w = math.max(dashboard_w, strw(line))

    local col = math.floor(winw / 2 - math.floor(strw(line) / 2)) - 6
    table.insert(ui, { virt_text_win_col = math.max(col, 0), virt_text = { { line, 'ODashAscii' } } })
  end

  local buttons = get_buttons()
  local group_widths = {}
  local button_widths = {}
  local key_lines = {}

  for i, item in ipairs(buttons) do
    local width

    if item.multicolumn then
      width = multicolumn_width(item, action == 'open' and buf or nil)
      button_widths[i] = width
    else
      local txt = icon_prefix(item) .. button_txt(item)
      width = strw(txt .. (item.keys or ''))
    end

    dashboard_w = math.max(dashboard_w, width)

    if item.group then
      group_widths[item.group] = math.max(group_widths[item.group] or 0, width)
    end
  end

  if group_widths.footer and group_widths.actions and group_widths.footer > 2 then
    group_widths.actions = math.max(group_widths.actions, group_widths.footer - 2)
  end

  for i, item in ipairs(buttons) do
    local width = dashboard_w
    local col
    local extmark
    local cursor_col

    if item.multicolumn then
      if item.content == 'fit' or item.group then
        width = group_widths[item.group] or button_widths[i]
      end

      col = math.floor(winw / 2 - math.floor(width / 2)) - 6
      cursor_col = math.max(col, 0)
      extmark = { virt_text_win_col = cursor_col, virt_text = multicolumn_virt_texts(item, width, button_widths[i]) }
    else
      local str = button_txt(item)

      if item.content == 'fit' or item.group then
        width = group_widths[item.group] or strw(str)
      end

      col = math.floor(winw / 2 - math.floor(width / 2)) - 6
      local prefix_w = strw(icon_prefix(item))
      cursor_col = math.max(col, 0) + prefix_w
      extmark = { virt_text_win_col = math.max(col, 0), virt_text = button_virt_text(item, width) }
    end

    table.insert(ui, extmark)

    if item.cmd then
      table.insert(key_lines, { i = #ui, cmd = item.cmd, col = math.max(cursor_col, 0) })
    end

    if not item.no_gap then
      table.insert(ui, { virt_text = { { '' } } })
    end

    if item.keys and item.cmd then
      map({ item.keys }, '<cmd>' .. item.cmd .. '<cr>', buf)
    end
  end

  local dashboard_h = #ui + 3
  winh = dashboard_h > winh and dashboard_h or winh

  local row_i = math.floor(winh / 2 - dashboard_h / 2)

  for i, line in ipairs(key_lines) do
    key_lines[i].i = line.i + row_i + 1
  end

  local empty_lines = {}
  for i = 1, winh do
    -- Real spaces let Neovim place the cursor on virtual-text labels instead
    -- of clamping it to the start of each empty dashboard row.
    empty_lines[i] = string.rep(' ', winw)
  end

  vim.bo[buf].modifiable = true
  api.nvim_buf_set_lines(buf, 0, -1, false, empty_lines)
  api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for i, item in ipairs(ui) do
    api.nvim_buf_set_extmark(buf, ns, row_i + i, 0, item)
  end

  if action == 'redraw' then
    vim.bo[buf].modifiable = false
    return
  end

  vim.wo[win].virtualedit = 'all'

  if key_lines[1] then
    api.nvim_win_set_cursor(win, { key_lines[1].i, key_lines[1].col })
  end

  ---@param n integer
  ---@param run boolean
  ---@return integer[]?
  local function key_movement(n, run)
    local curline = vim.fn.line '.'

    for i, line in ipairs(key_lines) do
      if line.i == curline then
        local target = key_lines[i + n] or key_lines[n == 1 and 1 or #key_lines]
        if run and target.cmd then
          vim.cmd(target.cmd)
          return nil
        end

        return { target.i, target.col }
      end
    end
  end

  map({ 'k', '<up>' }, function()
    local cursor = key_movement(-1, false)
    if cursor then api.nvim_win_set_cursor(win, cursor) end
  end, buf)

  map({ 'j', '<down>' }, function()
    local cursor = key_movement(1, false)
    if cursor then api.nvim_win_set_cursor(win, cursor) end
  end, buf)

  map({ '<cr>' }, function() key_movement(0, true) end, buf)

  set_clean_buffer_options(buf)
  vim.g.odash_displayed = true

  local group = api.nvim_create_augroup('ODash', { clear = true })

  api.nvim_create_autocmd('BufWinLeave', {
    group = group,
    buffer = buf,
    callback = function()
      vim.g.odash_displayed = false
      restore_statusline()
      pcall(api.nvim_del_augroup_by_name, 'ODash')
    end,
  })

  api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
    group = group,
    callback = function()
      if vim.g.odash_buf and api.nvim_buf_is_valid(vim.g.odash_buf) then
        M.open(vim.g.odash_buf, vim.g.odash_win, 'redraw')
      end
    end,
  })
end

---@param user_opts? ODashConfig
function M.setup(user_opts)
  opts = vim.tbl_deep_extend('force', vim.deepcopy(defaults), user_opts or {})
  set_highlights()

  api.nvim_create_user_command('ODash', function() M.open() end, { desc = 'Open ODash dashboard', force = true })

  local startup_group = api.nvim_create_augroup('ODashStartup', { clear = true })

  if opts.load_on_startup then
    api.nvim_create_autocmd('VimEnter', {
      group = startup_group,
      callback = function()
        if vim.fn.argc() > 0 or vim.bo.filetype == 'lazy' then return end
        M.open()
      end,
    })
  end
end

return M
