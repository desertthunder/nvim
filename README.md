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

## Updating the Config

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
rsync -a --delete --exclude '.git/' --exclude '.vscode/' ./ "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"
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
