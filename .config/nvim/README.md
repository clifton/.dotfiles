# Minimalist Neovim Configuration

A clean, modern, and minimalist Neovim configuration using lazy.nvim as the package manager and mini.nvim for core functionality.

## Features

- 🚀 Fast startup with lazy loading
- 🧩 Modular configuration
- 🎨 Beautiful UI with Kanagawa colorscheme
- 📦 Comprehensive mini.nvim plugins for lightweight functionality
- 🔍 mini.pick for fuzzy finding (replacing Telescope)
- 🧠 LSP support with auto-completion
- 🤖 Claude AI integration with Avante.nvim
- ⌨️ Sensible keymaps
- ✨ Smooth animations with mini.animate

## Structure

```
.
├── init.lua                 # Entry point
├── lua
│   ├── config
│   │   ├── keymaps.lua      # Key mappings
│   │   ├── lazy.lua         # Lazy.nvim setup
│   │   └── options.lua      # Neovim options
│   └── plugins
│       ├── avante.lua       # Avante.nvim (Claude AI) configuration
│       ├── core.lua         # Core plugins
│       ├── format.lua       # Formatting configuration
│       ├── lsp.lua          # LSP configuration
│       ├── mini.lua         # Mini.nvim plugins
│       └── pick.lua         # mini.pick configuration (replacing telescope.lua)
└── README.md                # Documentation
```

## Key Mappings

Leader key: `,`
Local leader key: `\`

### General

- `,<leader>` - Switch between last two buffers
- `,v` - Select last yanked/pasted text
- `;` - Command mode (instead of `:`)
- `,s` - Toggle spell checking
- `,<space>` - Clear search highlighting
- `<tab>` - Jump to matching bracket
- `<F5>` - Remove trailing whitespace

### Windows/Panes

- `,w` - Split window vertically
- `,W` - Split window horizontally
- `<C-h/j/k/l>` - Navigate between windows

### File Operations

- `,e` - Edit file in same directory
- `,rl` - Reload configuration
- `,rv` - Edit configuration
- `,rm` - Delete current file and buffer

### mini.pick (Replacing Telescope)

- `<C-p>` - Find files in current directory
- `,f` - Find files
- `,fa` - Find all files (including hidden, ignoring gitignore)
- `,.` - Recent files
- `,gb` - List buffers
- `,gf` - Find files in current file's directory
- `,gv` - Find views
- `,rg` - Live grep
- `,h` - Help pages
- `,/` - Grep with pattern
- `,:` - Commands
- `,k` - Keymaps
- `,z` - Resume last picker

### mini.nvim Modules

- `<Alt-h/j/k/l>` - Move lines or selections (mini.move)
- `f/F/t/T` - Enhanced jump motions (mini.jump)
- `gc/gcc` - Comment code (mini.comment)
- `sa/sd/sr` - Add/delete/replace surroundings (mini.surround)
- `sf/sF` - Find surroundings (mini.surround)
- `gS` - Toggle split/join arguments (mini.splitjoin)
- `ga/gA` - Align text (mini.align)
- `,<tab>` - Open scratch buffer

### LSP with mini.pick

- `gd` - Go to definition
- `gr` - Find references
- `gI` - Go to implementation
- `,D` - Type definition
- `,ds` - Document symbols
- `,ws` - Workspace symbols
- `,rn` - Rename
- `,cf` - Format
- `,ca` - Code action
- `K` - Hover documentation

### Formatting

- `<F3>` - Format current buffer
- `,cf` - Format current buffer
- `,tf` - Toggle format on save
- `:ToggleFormatOnSave` - Toggle format on save (command)

Format on save is enabled by default for all supported file types. Formatting is handled by conform.nvim with the following formatters:

- stylua (Lua)
- prettier (JavaScript/TypeScript/HTML/CSS/JSON/YAML/Markdown)
- ruff_format (Python)
- shfmt (Shell scripts)
- rustfmt (Rust)
- taplo (TOML)

If a formatter isn't available, it will fall back to LSP formatting.

### Avante.nvim (Claude AI)

- `,a` - Toggle Avante window
- `<Ctrl-s>` - Submit prompt (in Avante window)
- `<Ctrl-l>` - Clear conversation (in Avante window)
- `q` - Close Avante window
- `<Ctrl-b/f>` - Scroll up/down in Avante window

#### Inline Completions

- `<Alt-l>` - Accept suggestion
- `<Alt-w>` - Accept word
- `<Alt-o>` - Accept line
- `<Alt-]>` - Next suggestion
- `<Alt-[>` - Previous suggestion
- `<Ctrl-]>` - Dismiss suggestion
- `,ti` - Toggle Avante inline completions

## mini.nvim Modules Used

This configuration uses the following mini.nvim modules:

- **mini.ai** - Better text objects
- **mini.align** - Align text interactively
- **mini.animate** - Smooth animations for cursor, scrolling, and windows
- **mini.bufremove** - Better buffer removal
- **mini.comment** - Code commenting (replaces Comment.nvim)
- **mini.cursorword** - Highlight word under cursor
- **mini.files** - File explorer
- **mini.hipatterns** - Highlight patterns in text
- **mini.indentscope** - Show scope based on indentation (replaces indent-blankline.nvim)
- **mini.jump** - Better f/t motions
- **mini.move** - Move lines and selections
- **mini.pairs** - Auto pairs
- **mini.pick** - Fuzzy finder (replaces Telescope)
- **mini.splitjoin** - Split and join arguments (replaces splitjoin.vim)
- **mini.statusline** - Minimal status line
- **mini.surround** - Surround text objects (replaces nvim-surround)
- **mini.trailspace** - Highlight and remove trailing whitespace

## Installation

1. Backup your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on the first run.

4. Set up Claude API key:
   ```bash
   # Add this to your .bashrc, .zshrc, or equivalent
   export ANTHROPIC_API_KEY="your_claude_api_key_here"
   ```

## Startup Commands

You can start Neovim with the file finder already open:

```bash
# Open mini.pick file finder on startup
nvim +PickFiles

# Open mini.pick file finder with specific directory
nvim +PickFiles\ cwd=/path/to/directory

# Open mini.pick file finder with gitignore disabled
nvim +PickFiles\ no_ignore=true

# Combine options
nvim +PickFiles\ "cwd=/path/to/directory no_ignore=true"
```

Note: If you're using this in a shell script or alias, you may need to escape the backslash:
```bash
# In a shell script or alias
alias nv='nvim +PickFiles\\ cwd=.'
```

## Customization

- Add new plugins in `lua/plugins/` directory
- Modify keymaps in `lua/config/keymaps.lua`
- Change Neovim options in `lua/config/options.lua`
- Configure mini.nvim modules in `lua/plugins/mini.lua`