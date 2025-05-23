# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize Homebrew for macOS or Linux
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  # macOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  # Linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

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

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# bash word style (must be before plugins are loaded)
autoload -U select-word-style
select-word-style bash

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zdharma-continuum/fast-syntax-highlighting
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light birdhackor/zsh-eza-ls-plugin
zinit light MenkeTechnologies/zsh-cargo-completion

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
zinit ice as"completion" id-as"carapace-shims" \
    atload"source <(carapace _carapace zsh)"
zinit light zdharma-continuum/null

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
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"
zinit wait lucid light-mode for lukechilds/zsh-nvm

source $HOME/.aliases

# only source the env file if it exists
if [ -f "$HOME/.env" ]; then
  source $HOME/.env
fi

# only source the cargo env file if it exists
if [ -f "$HOME/.cargo/env" ]; then
  source $HOME/.cargo/env
fi

export PATH="$PATH:$HOME/.local/bin"

# pnpm
export PNPM_HOME="/Users/clifton/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add Windows explorer.exe to PATH in WSL environment
if [ -f /proc/version ] && grep -q "microsoft" /proc/version; then
  # Get Windows system32 path and convert it to WSL path format
  WINDOWS_DIR=$(wslpath -u "$(wslvar SYSTEMROOT)")
  # Add only explorer.exe by using a function instead of PATH modification
  function explorer() {
    "${WINDOWS_DIR}/explorer.exe" "$@"
  }

  function cmd() {
    "${WINDOWS_DIR}/system32/cmd.exe" "$@"
  }

  # Set XDG_RUNTIME_DIR to a user-writable location
  export XDG_RUNTIME_DIR="$HOME/.xdg_runtime"
  if [ ! -d "$XDG_RUNTIME_DIR" ]; then
      mkdir -p "$XDG_RUNTIME_DIR"
      chmod 0700 "$XDG_RUNTIME_DIR"
  fi
fi
