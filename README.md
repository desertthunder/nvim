# Neovim Configuration

## Configured Languages

- Lua
- Go
- Rust
- TypeScript+JavaScript / JSX+TSX
- Markdown
- Bash
- C
- C++

## Update Config

```sh
mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
rsync -a --delete --exclude '.git/' --exclude '.vscode/' ./ "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/"
```
