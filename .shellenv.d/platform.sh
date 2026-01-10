# Platform detection for dotfiles
# Evaluated once at shell startup, exports variables for use by other scripts

# Detect operating system
case "$(uname -s)" in
  Darwin) DOTFILES_OS="macos" ;;
  Linux)  DOTFILES_OS="linux" ;;
  *)      DOTFILES_OS="unknown" ;;
esac

# Detect architecture
DOTFILES_ARCH="$(uname -m)"

# WSL detection
DOTFILES_IS_WSL=false
if [ -f /proc/version ] && grep -qi "microsoft" /proc/version 2>/dev/null; then
  DOTFILES_IS_WSL=true
fi

# SSH session detection
DOTFILES_IS_SSH=false
[ -n "$SSH_CONNECTION" ] && DOTFILES_IS_SSH=true

# Detect Homebrew prefix (cached, not evaluated repeatedly)
DOTFILES_HOMEBREW_PREFIX=""
if [ "$DOTFILES_OS" = "macos" ]; then
  if [ -f "/opt/homebrew/bin/brew" ]; then
    DOTFILES_HOMEBREW_PREFIX="/opt/homebrew"
  elif [ -f "/usr/local/bin/brew" ]; then
    DOTFILES_HOMEBREW_PREFIX="/usr/local"
  fi
elif [ "$DOTFILES_OS" = "linux" ] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  DOTFILES_HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
fi

export DOTFILES_OS DOTFILES_ARCH DOTFILES_IS_WSL DOTFILES_IS_SSH DOTFILES_HOMEBREW_PREFIX
