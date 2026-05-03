# Snippets Memo

- Current snippet setup on this Mac uses `blink.cmp` built-in snippets, not `LuaSnip`.
- Snippet files live under [nvim/snippets](/Users/th13/code/dotfiles/nvim/snippets:1).
- Entry file is [nvim/snippets/package.json](/Users/th13/code/dotfiles/nvim/snippets/package.json:1).
- Language-specific snippet bodies live in files like [nvim/snippets/java.json](/Users/th13/code/dotfiles/nvim/snippets/java.json:1).
- JSON format is VS Code style:
  - snippet name as the object key
  - `prefix`
  - `body`
  - `description`

## Windows Side Notes

- If this Java snippet is copied to the Windows dotfiles, also copy:
  - `nvim/snippets/package.json`
  - `nvim/snippets/java.json`
- Windows `nvim/init.lua` must have `blink.cmp` snippet source enabled:
  - `sources.default` should include `"snippets"`
- To show snippet descriptions in the completion menu, Windows `nvim/init.lua` should also include:

```lua
sources = {
  default = { "lsp", "path", "snippets" },
  providers = {
    snippets = {
      opts = {
        use_label_description = true,
      },
    },
  },
}
```

- Current Java example:
  - prefix: `sout`
  - description: `Print a value to standard output`

- `blink.cmp` shows the prefix as the main label, so keep `description` short if you want it to fit in the menu.
