# Dotfiles

A comprehensive dotfiles repository for cross-platform development environments, with a focus on Windows-Linux (WSL) interoperability and modern terminal tools.

## Features

- **Cross-Platform Support**
  - Linux/WSL: Primary development environment with ZSH configuration
  - Windows: PowerShell configuration that mirrors the Linux experience
  - macOS: Support for macOS-specific tools

- **Integrated Environments**
  - Windows OpenSSH integration with automatic SSH key management
  - Seamless configuration sharing between Linux and Windows
  - Consistent Git experience across platforms

- **Core Tools Configuration**
  - **Shell Environments**:
    - ZSH with zinit plugin manager and Powerlevel10k theme
    - PowerShell with Oh My Posh and Linux-like aliases
    - Extensive shell aliases for Git, navigation, and utilities
  
  - **Terminal Multiplexers**:
    - tmux with custom configuration and plugins (tmux-cpu, tmux-fzf-url, tmux-thumbs)
    - Session management with sesh integration
    - Kanagawa theme for consistent styling

  - **Text Editors**:
    - Neovim configuration with lazy.nvim plugin manager
    - mini.nvim suite for lightweight, focused functionality
    - Kanagawa colorscheme (wave theme) for consistent visuals
    - Claude AI integration through Avante.nvim for intelligent coding assistance

  - **Git Tools**:
    - Extensive Git aliases and configurations
    - git-delta for improved diffs
    - GitHub shortcuts and URL manipulation

  - **Session Management**:
    - sesh for smart terminal session management
    - Custom tmux integration for session switching with FZF

## Installation

### Linux/macOS Setup

This repository uses GNU Stow for dotfile management. To install:

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install everything
stow .

# Or install specific components
stow .zshrc .config/nvim
```

### Windows PowerShell Setup

For Windows installation instructions, see the [PowerShell README](PowerShell/README.md). The included script automates installation from WSL to Windows.

## ZSH Configuration

The ZSH setup includes:

- **Plugin Management**: Uses zinit for fast, flexible plugin loading
- **Completion System**: Enhanced with fzf-tab and carapace for smarter suggestions
- **Theme**: Powerlevel10k for a customizable, informative prompt
- **Performance**: Optimized for fast startup with async loading
- **Key Plugins**:
  - fast-syntax-highlighting for real-time command coloring
  - zsh-autosuggestions for history-based suggestions
  - zsh-cargo-completion for Rust development
  - zoxide for smarter directory navigation

## Neovim Configuration

The Neovim setup is modern and minimal:

- **Plugin Management**: lazy.nvim for efficient plugin loading
- **Core Theme**: Kanagawa (wave theme) for a clean, distraction-free experience
- **Mini Ecosystem**: Leverages mini.nvim for lightweight, focused functionality:
  - mini.ai - Better text objects
  - mini.pairs - Auto pairs
  - mini.statusline - Minimal status line
  - mini.files - File explorer
  - mini.comment - Code commenting
  - mini.surround - Surround text operations
  - mini.align - Text alignment tools
  - mini.move - Line and selection movement

- **AI Integration**: Avante.nvim plugin for Claude AI assistance with:
  - Context-aware code completions
  - Inline suggestions
  - Dedicated AI chat window

- **File Picker**: fzf-lua integration for fast fuzzy finding:
  - File navigation (`<C-p>`, `<leader>f`)
  - Recent files (`<leader>.`)
  - Buffer management (`<leader>gb`)
  - Live grep with ripgrep (`<leader>rg`, `<leader>/`)
  - Git integration (`<leader>gc`, `<leader>gs`)

- **LSP Integration**: Comprehensive language server support:
  - Automatic server installation via mason.nvim
  - Smart completions with nvim-cmp
  - Diagnostics and code actions
  - Fuzzy finder integration for references, definitions, and symbols
  - Built-in formatters via conform.nvim
  - Python, Lua, Rust, JavaScript/TypeScript support out of the box

## tmux Configuration

The tmux setup provides an enhanced terminal multiplexer experience:

- **Theme**: Clean, informative status line with Kanagawa-inspired colors
- **Keybindings**: Custom mappings for efficient pane/window navigation
- **Plugins**:
  - tmux-cpu for system monitoring
  - tmux-fzf-url for URL extraction and opening
  - tmux-thumbs for quick text selection
  - tmux-floax for floating terminal windows
  - tmux-kanagawa for consistent theme integration

- **Vim Integration**: Seamless navigation between Vim and tmux panes
- **Session Management**: Integration with sesh for smart session handling

## Additional Features

- **Cross-platform Consistency**: Similar aliases between PowerShell and ZSH
- **Modern Terminal Tools**: 
  - FZF for fuzzy finding
  - eza/exa for improved directory listings
  - zoxide for smart directory navigation
- **WSL Integration**: Automatically configures Windows to work seamlessly with Linux

## License

MIT