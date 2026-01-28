# Source shared shell environment
if [ -f "$HOME/.shellenv" ]; then
  . "$HOME/.shellenv"
fi

# History settings
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Simple colored prompt
PS1='\[\e[32m\]\u@\h\[\e[0m\]:\[\e[34m\]\w\[\e[0m\]\$ '

# Enable color support
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  
fi

# fzf integration
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash 2>/dev/null)" || true
fi

# zoxide integration
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# Auto-setup SSH agent on shell startup
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS: load SSH keys from keychain
  if ! ssh-add -l &>/dev/null; then
    ssh-add --apple-load-keychain -q 2>/dev/null || true
  fi
else
  # Linux: Set SSH_AUTH_SOCK to systemd user agent if available
  _systemd_socket="/run/user/$(id -u)/ssh-agent.socket"
  if [ -S "$_systemd_socket" ]; then
    export SSH_AUTH_SOCK="$_systemd_socket"
  fi
  unset _systemd_socket
fi

# Bash completion
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# Homebrew bash completion
if command -v brew &>/dev/null; then
  if [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi
