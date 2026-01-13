#!/bin/bash
# Install recommended tools for dotfiles
# Usage: ./scripts/install-tools.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install it first:"
    echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

print_status "Homebrew found"

# Core tools
CORE_TOOLS="fzf zoxide eza bat ripgrep git-delta sesh gum gh"

echo ""
echo "Installing core tools..."
for tool in $CORE_TOOLS; do
    if brew list "$tool" &> /dev/null; then
        print_status "$tool already installed"
    else
        echo "  Installing $tool..."
        if brew install "$tool"; then
            print_status "$tool installed"
        else
            print_error "Failed to install $tool"
        fi
    fi
done

# Worktrunk (from tap)
echo ""
echo "Installing worktrunk..."
if brew list wt &> /dev/null; then
    print_status "worktrunk already installed"
else
    echo "  Adding tap max-sixty/worktrunk..."
    brew tap max-sixty/worktrunk 2>/dev/null || true
    if brew install max-sixty/worktrunk/wt; then
        print_status "worktrunk installed"
    else
        print_error "Failed to install worktrunk"
    fi
fi

# Configure worktrunk shell integration
if command -v wt &> /dev/null; then
    echo ""
    echo "Configuring worktrunk shell integration..."
    if wt config shell install; then
        print_status "worktrunk shell integration configured"
    else
        print_warning "worktrunk shell integration may already be configured"
    fi
else
    print_warning "worktrunk not found, skipping shell integration"
fi

echo ""
print_status "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Run 'dotfiles-check' to verify your setup"
