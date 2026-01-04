# Source shared shell environment
[[ -f "$HOME/.shellenv" ]] && source "$HOME/.shellenv"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# Skip in screen sessions - screen mangles Unicode
if [[ -z "$STY" && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh-specific: Add Homebrew completions to FPATH
if type brew &>/dev/null; then
  export FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Install Oh My Tmux if not present (https://github.com/gpakosz/.tmux)
if command -v tmux &>/dev/null && [ ! -d "$HOME/.tmux" ]; then
  echo "Installing Oh My Tmux..."
  git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
  ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
  # Note: .tmux.conf.local is managed by dotfiles, not copied from oh-my-tmux
  echo "Oh My Tmux installed!"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# bash word style (must be before plugins are loaded)
autoload -U select-word-style
select-word-style bash

# Add in Powerlevel10k (skip in screen sessions)
if [[ -z "$STY" ]]; then
  zinit ice depth=1; zinit light romkatv/powerlevel10k
fi

# Add in zsh plugins
zinit light zdharma-continuum/fast-syntax-highlighting
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light birdhackor/zsh-eza-ls-plugin
zinit light MenkeTechnologies/zsh-cargo-completion

# Configure zsh-autosuggestions color (one shade lighter using xterm-256)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# Add in snippets
zinit snippet OMZL::async_prompt.zsh
# zinit snippet OMZL::git.zsh
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::command-not-found
# zinit snippet OMZP::docker-compose
# zinit snippet OMZP::python
# zinit snippet OMZP::ssh
# zinit ice as"completion"
# zinit snippet https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker


# Load completions
autoload -Uz compinit && compinit

# Add Carapace as a Zinit plugin (add this before other completions)
zinit ice from"gh-r" as"program" mv"carapace* -> carapace"
zinit light carapace-sh/carapace-bin

# Initialize Carapace (add after the plugin installation, before compinit)
# DISABLED: carapace causes double-escaping of spaces with fzf-tab
# zinit ice as"completion" id-as"carapace-shims" \
#     atload"source <(carapace _carapace zsh)"
# zinit light zdharma-continuum/null

zinit light Aloxaf/fzf-tab  # load after compinit

zinit cdreplay -q

# Oh My Posh setup for both macOS and Linux
setup_oh_my_posh() {
  # Check if Oh My Posh is installed
  if ! command -v oh-my-posh &> /dev/null; then
    echo "Oh My Posh not found. Installing..."

    # Install Oh My Posh based on platform
    if [[ "$OSTYPE" == "darwin"* ]]; then
      # macOS installation
      brew install jandedobbeleer/oh-my-posh/oh-my-posh
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
      # Linux installation
      if command -v brew &> /dev/null; then
        # Use Homebrew if available
        brew install jandedobbeleer/oh-my-posh/oh-my-posh
      else
        # Use the official installer script
        curl -s https://ohmyposh.dev/install.sh | bash -s
      fi
    fi

    echo "Oh My Posh installed successfully!"
  fi

  # Set up Oh My Posh theme
  # Use a default theme from the themes directory
  local theme_path="$(brew --prefix oh-my-posh 2>/dev/null)/themes/jandedobbeleer.omp.json"

  # If brew path doesn't exist, try the standard path
  if [[ ! -f "$theme_path" ]]; then
    if [[ -d "$HOME/.poshthemes" ]]; then
      theme_path="$HOME/.poshthemes/jandedobbeleer.omp.json"
    elif [[ -d "/usr/local/share/oh-my-posh/themes" ]]; then
      theme_path="/usr/local/share/oh-my-posh/themes/jandedobbeleer.omp.json"
    fi
  fi

  # Initialize Oh My Posh if theme exists
  if [[ -f "$theme_path" ]]; then
    eval "$(oh-my-posh init zsh --config $theme_path)"
    echo "Oh My Posh initialized with theme: $theme_path"
  else
    # If no theme file found, initialize with default
    eval "$(oh-my-posh init zsh)"
    echo "Oh My Posh initialized with default theme"
  fi
}

# Comment out powerlevel10k if you want to use Oh My Posh instead
# Uncomment the line below to set up Oh My Posh
# setup_oh_my_posh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# Use simple prompt in screen sessions, p10k otherwise
if [[ -n "$STY" ]]; then
  PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
else
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:descriptions' format '[%d]'

# fzf-tab configuration
zstyle ':fzf-tab:*' continuous-trigger 'space'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Fix for fzf-tab passing the directory as query
zstyle ':fzf-tab:*' query-string prefix

# Fix double-escaping issue with fzf-tab
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true

# Disable popup mode - use full terminal
zstyle ':fzf-tab:*' fzf-command fzf

# fzf layout and preview configuration
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border --preview-window=right:50%:wrap --bind='ctrl-/:toggle-preview'

# File/directory preview
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  target=${realpath:-$word}
  target=${target%% }
  target=${~target}
  [[ -d $target ]] && eza -1 --color=always -- "$target" 2>/dev/null
  [[ -f $target ]] && bat --style=numbers --color=always --line-range=:100 -- "$target" 2>/dev/null
'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# NVM (zsh-specific lazy loading via zinit)
zinit wait lucid light-mode for lukechilds/zsh-nvm

# macOS: load SSH keys from keychain
if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! ssh-add -l &>/dev/null; then
    ssh-add --apple-load-keychain -q
  fi
fi

# Auto-attach to tmux on SSH connections
if [[ -z "$TMUX" && -n "$SSH_CONNECTION" ]]; then
  tmux new -A -s main
fi
