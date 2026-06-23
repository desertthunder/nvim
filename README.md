# Neovim Configuration

## Configured Languages

- Lua
- Gleam
- Go
- Rust
- TypeScript+JavaScript / JSX+TSX
- Markdown
- Bash
- C
- C++
- Zig

## `mini.ai` Text Objects

| Text object              | Behavior                                                                      |
| ------------------------ | ----------------------------------------------------------------------------- |
| `ac` / `ic`              | Around/inside a class-like Tree-sitter capture.                               |
| `af` / `if`              | Around/inside a function or method Tree-sitter capture.                       |
| `aa` / `ia`              | Around/inside an argument or list item, from `mini.ai`.                       |
| `at` / `it`              | Around/inside an HTML-like tag, from `mini.ai`.                               |
| `aq` / `iq`, `aQ` / `iQ` | Around/inside any quote: single, double, or backtick.                         |
| `ab` / `ib`, `aB` / `iB` | Around/inside any bracket: `()`, `[]`, `{}`, or `<>`.                         |
| `ai` / `ii`              | Current indent block, with `ai` also including one line before.               |
| `aI` / `iI`              | Current indent block, with `aI` including one line before and one line after. |

The class/function objects are powered by `nvim-treesitter-textobjects` query
captures, so they depend on the active language having those captures.

## Updating the Config

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
rsync -a --delete --exclude '.git/' --exclude '.sandbox/' ./ "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"
```

### Updating Plugins

`vim.pack` writes `nvim-pack-lock.json` to the active Neovim config directory. After updating
plugins in the rsynced config, copy the lockfile back into this repo before committing:

```sh
nvim +'lua vim.pack.update()'
cp "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/nvim-pack-lock.json" ./nvim-pack-lock.json
```

## To-Do

- [ ] Add language support for dart and elixir
- [ ] Add svelte, tailwind, astro, and heex support
