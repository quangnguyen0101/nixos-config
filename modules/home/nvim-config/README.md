# nvim-config

Personal Neovim configuration powered by [lazy.nvim](https://github.com/folke/lazy.nvim).

Leader key: `<Space>`. Press `<Space>?` to show all keymaps via [which-key](https://github.com/folke/which-key.nvim).

## Keymaps

### Editor

| Key | Action |
|:---:|:------|
| `<C-d>` / `<C-u>` | Scroll down/up (centered) |
| `<C-s>` | Save |
| `<C-q>` | Quit |
| `<A-Left>` / `<A-Right>` | Start / End of line |
| `<leader>w` | Save |

### Explorer

| Key | Action |
|:---:|:------|
| `<leader>e` | Toggle Neotree |

### Split / Window (`<leader>s`)

| Key | Action |
|:---:|:------|
| `sv` | Vertical split |
| `sh` | Horizontal split |
| `sx` | Close split |
| `so` | Close other splits |
| `sr` | Rotate splits |
| `<A-]>` / `<A-[>` | Grow / Shrink height |
| `<A-.>` / `<A-,>` | Grow / Shrink width |
| `<A-=>` | Equalize splits |
| `<C-arrows>` | Navigate splits |

### Buffer (`<leader>b`)

| Key | Action |
|:---:|:------|
| `<S-l>` / `<S-h>` | Next / Prev buffer |
| `b>` / `b<` | Move buffer right/left |
| `bp` | Pick buffer |
| `bi` | Pin buffer |
| `bx` | Close buffer |
| `1`-`9` | Go to buffer N |

### Find (`<leader>f`)

| Key | Action |
|:---:|:------|
| `ff` | Find files |
| `fg` | Live grep |
| `fb` | Buffers |
| `fh` | Help tags |

### Git (`<leader>g`)

| Key | Action |
|:---:|:------|
| `gs` | Git status |
| `gc` | Git commits |
| `gb` | Git branches |
| `gd` | Git diff |
| `gf` | Git files |

### Code (`<leader>c`)

| Key | Action |
|:---:|:------|
| `ce` | Copy diagnostic message |
| `ca` | Code action |

### LSP (`<leader>l`)

| Key | Action |
|:---:|:------|
| `rn` | Rename symbol |
| `fm` | File symbols |

Also standard `g`-prefix mappings: `gd` (definition), `gi` (implementation), `gr` (references), `gD` (declaration), `K` (hover).

### AI (`<leader>a`)

| Key | Action |
|:---:|:------|
| `ac` | AI Chat (CodeCompanion) |
| `ae` | AI Actions (visual) |
| `aa` | AI Inline |

### Opencode (`<leader>o`)

| Key | Action |
|:---:|:------|
| `oa` | Ask opencode |
| `ox` | Select opencode |
| `ot` | Toggle opencode |
| `ob` | Open file in browser |
| `ou` / `od` | Scroll opencode up/down |
| `go` / `goo` | Operator: add range/line |

### Debug / DAP (`<leader>d`)

| Key | Action |
|:---:|:------|
| `db` | Toggle breakpoint |
| `dc` | Continue |
| `do` | Step over |
| `di` | Step into |
| `dx` | Terminate |
| `du` | Toggle DAP UI |

### Terminal (`<leader>t`)

| Key | Action |
|:---:|:------|
| `<F10>` | Toggle terminal |
| `th` | Horizontal terminal |
| `tv` | Vertical terminal |
| `tf` | Float terminal |

### Notifications (`<leader>n`)

| Key | Action |
|:---:|:------|
| `nm` | Show messages |
| `nd` | Dismiss |

### UI (`<leader>u`)

| Key | Action |
|:---:|:------|
| `ut` | Cycle theme |

### Yank (`<leader>y`)

| Key | Action |
|:---:|:------|
| `yc` | Copy file path |

### Misc

| Key | Action |
|:---:|:------|
| `]t` / `[t` | Next / Prev TODO |
| `]d` / `[d` | Next / Prev diagnostic |
| `<leader>st` | Show directory tree |
| `<leader>dd` | Delete line to void |
| `<leader>d` (visual) | Delete selection to void |
| `<leader>p` (visual) | Paste without yanking |
| `J` / `K` (visual) | Move line down/up |

## Plugins

- [lazy.nvim](https://github.com/folke/lazy.nvim) — package manager
- [tokyonight](https://github.com/folke/tokyonight.nvim) + [catppuccin](https://github.com/catppuccin/nvim) + [rose-pine](https://github.com/rose-pine/neovim) + [accent](https://github.com/alligator/accent.vim)
- [which-key](https://github.com/folke/which-key.nvim) — keymap discovery
- [telescope](https://github.com/nvim-telescope/telescope.nvim) — fuzzy finder
- [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) — file explorer
- [toggleterm](https://github.com/akinsho/toggleterm.nvim) — terminal
- [bufferline](https://github.com/akinsho/bufferline.nvim) — buffer tabs
- [lualine](https://github.com/nvim-lualine/lualine.nvim) — statusline
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) — autocompletion
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) — syntax highlighting
- [mason](https://github.com/williamboman/mason.nvim) — LSP installer
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) — debugger
- [codecompanion](https://github.com/olimorris/codecompanion.nvim) — AI chat
- [opencode](https://github.com/nickjvandyke/opencode.nvim)  — AI coding agent
- [Comment](https://github.com/numToStr/Comment.nvim) — code comments
- [noice](https://github.com/folke/noice.nvim) — UI enhancements
- [todo-comments](https://github.com/folke/todo-comments.nvim) — TODO highlights
- [alpha-nvim](https://github.com/goolord/alpha-nvim) — dashboard
- [conform](https://github.com/stevearc/conform.nvim) — formatter
- [nvim-lint](https://github.com/mfussenegger/nvim-lint) — linter
