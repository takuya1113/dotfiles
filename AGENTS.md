# AGENTS

- This repository is the source of truth for this Mac's dotfiles. Edit files in this repo, not the linked files under `$HOME`.
- Main terminal workflow on this Mac is `WezTerm -> tmux`.
- `tmux` is the primary multiplexer. `wezterm` should stay minimal and mainly handles appearance plus a small amount of key translation.
- In `wezterm`, `Ctrl-Space` is translated to the tmux prefix. The actual tmux prefix is `Ctrl-]`.
- `Cmd-Shift-b` in `wezterm` toggles the macOS blur effect.
- `tmux` config is managed in [tmux/tmux.conf](/Users/th13/code/dotfiles/tmux/tmux.conf:1) and linked to `~/.tmux.conf`.
- `wezterm` config is managed in [wezterm/wezterm.lua](/Users/th13/code/dotfiles/wezterm/wezterm.lua:1).
- This machine is an older Intel Mac running macOS 12.7.6.
- Homebrew on this machine is a compatibility risk. Some newer formulae may fail, rebuild from source, or need workarounds.
- `tmux` was installed via a local Homebrew tap workaround because the standard dependency path was unreliable on this machine.
