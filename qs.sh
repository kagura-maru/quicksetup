#!/usr/bin/env bash
# quicksetup.sh — Modular Kali Linux Quick Setup
# v1.0.0 — Rewritten from v0.11
#
# Usage:
#   ./quicksetup.sh all              # Run every module in order
#   ./quicksetup.sh list             # List available modules
#   ./quicksetup.sh zsh go copyq     # Run specific modules only
#   ./quicksetup.sh --help           # Show usage
#
# Modules:
#   base        — apt update/upgrade, core packages, Sublime Text repo
#   terminator  — Terminator terminal + Catppuccin profiles
#   zsh         — Oh My Zsh + plugins (autosuggestions, syntax-highlighting)
#   go          — Go toolchain
#   copyq       — CopyQ clipboard manager as a systemd user service
#   autorecon   — AutoRecon via pipx
#   aliases     — Desktop dirs, shell aliases, helper functions, PATH
#   scripts     — Additional helper scripts (ffuf-gen, nmap-parser)

set -euo pipefail

# ──────────────────────────────────────────────
# Globals
# ──────────────────────────────────────────────
VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_USER="${SUDO_USER:-$(whoami)}"
if command -v getent &>/dev/null; then
    SETUP_HOME="$(getent passwd "$SETUP_USER" | cut -d: -f6)"
else
    SETUP_HOME="$(eval echo "~$SETUP_USER")"
fi
ZSHRC="$SETUP_HOME/.zshrc"
GO_VERSION="1.25.5"
SCRIPTS_REPO="https://raw.githubusercontent.com/kagura-maru/quicksetup/refs/heads/main/scripts"

# ──────────────────────────────────────────────
# Logging helpers
# ──────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { printf "${BLUE}[!] %s${NC}\n" "$*"; }
success() { printf "${GREEN}[+] %s${NC}\n" "$*"; }
warn()    { printf "${YELLOW}[?] %s${NC}\n" "$*"; }
error()   { printf "${RED}[x] %s${NC}\n" "$*" >&2; }

run_as_user() {
    # Run a command as the target user (for when the script is run with sudo)
    if [ "$(id -u)" -eq 0 ] && [ "$SETUP_USER" != "root" ]; then
        sudo -u "$SETUP_USER" -H bash -c "$*"
    else
        bash -c "$*"
    fi
}

ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        info "Created directory: $dir"
    fi
}

append_once() {
    # Append a line to a file only if it doesn't already exist
    local file="$1" line="$2"
    if [ -f "$file" ] && grep -qF "$line" "$file" 2>/dev/null; then
        return 0
    fi
    echo "$line" >> "$file"
}

# ──────────────────────────────────────────────
# Module: base
# ──────────────────────────────────────────────
mod_base() {
    info "Setting up Sublime Text repository"
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
        | gpg --dearmor \
        | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

    echo "deb https://download.sublimetext.com/ apt/stable/" \
        | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null

    info "Updating and upgrading packages"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get remove -y needrestart || true

    info "Installing core packages"
    sudo apt-get install -y --fix-missing \
        copyq terminator sublime-text \
        gobuster seclists curl dnsrecon enum4linux feroxbuster \
        impacket-scripts nbtscan nikto nmap onesixtyone oscanner \
        redis-tools smbclient smbmap snmp sslscan sipvicious \
        tnscmd10g whatweb nuclei python3-venv locate

    sudo updatedb
    success "Base packages installed"
}

# ──────────────────────────────────────────────
# Module: terminator (+ Catppuccin)
# ──────────────────────────────────────────────
mod_terminator() {
    info "Configuring Terminator with Catppuccin profiles"

    if ! command -v terminator &>/dev/null; then
        info "Installing Terminator"
        sudo apt-get install -y terminator
    fi

    local config_dir="$SETUP_HOME/.config/terminator"
    local config_file="$config_dir/config"

    ensure_dir "$config_dir"

    # Back up existing config before overwriting
    if [ -f "$config_file" ]; then
        cp "$config_file" "${config_file}.bak.$(date +%s)"
        info "Backed up existing Terminator config"
    fi

    cat > "$config_file" << 'TERMINATOR_EOF'
[global_config]
[keybindings]
[profiles]
  [[default]]
    cursor_color = "#f5e0dc"
    background_color = "#1e1e2e"
    foreground_color = "#cdd6f4"
    background_darkness = 0.95
    background_type = transparent
    show_titlebar = False
    scrollback_infinite = True
    palette = "#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"
    background_image = None
  [[Catppuccin_Latte]]
    cursor_color = "#dc8a78"
    background_color = "#eff1f5"
    foreground_color = "#4c4f69"
    show_titlebar = False
    scrollback_infinite = True
    palette = "#5c5f77:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#acb0be:#6c6f85:#d20f39:#40a02b:#df8e1d:#1e66f5:#ea76cb:#179299:#bcc0cc"
    background_image = None
  [[Catppuccin_Frappe]]
    cursor_color = "#f2d5cf"
    background_color = "#303446"
    show_titlebar = False
    scrollback_infinite = True
    foreground_color = "#c6d0f5"
    palette = "#51576d:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#b5bfe2:#626880:#e78284:#a6d189:#e5c890:#8caaee:#f4b8e4:#81c8be:#a5adce"
    background_image = None
  [[Catppuccin_Macchiato]]
    cursor_color = "#f4dbd6"
    background_color = "#24273a"
    show_titlebar = False
    scrollback_infinite = True
    foreground_color = "#cad3f5"
    palette = "#494d64:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#b8c0e0:#5b6078:#ed8796:#a6da95:#eed49f:#8aadf4:#f5bde6:#8bd5ca:#a5adcb"
    background_image = None
  [[Catppuccin_Mocha]]
    cursor_color = "#f5e0dc"
    background_color = "#1e1e2e"
    show_titlebar = False
    scrollback_infinite = True
    foreground_color = "#cdd6f4"
    palette = "#45475a:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#bac2de:#585b70:#f38ba8:#a6e3a1:#f9e2af:#89b4fa:#f5c2e7:#94e2d5:#a6adc8"
    background_image = None
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
TERMINATOR_EOF

    success "Terminator configured with Catppuccin profiles"
}

# ──────────────────────────────────────────────
# Module: zsh
# ──────────────────────────────────────────────
mod_zsh() {
    if [ -d "$SETUP_HOME/.oh-my-zsh" ]; then
        warn "Oh My Zsh already installed — skipping"
        return 0
    fi

    info "Installing Oh My Zsh"
    # --unattended: no chsh prompt, no interactive zsh launch
    run_as_user 'sh -c "$(wget -q https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" "" --unattended'

    info "Installing zsh plugins"
    local custom_plugins="$SETUP_HOME/.oh-my-zsh/custom/plugins"

    if [ ! -d "$custom_plugins/zsh-autosuggestions" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
            "$custom_plugins/zsh-autosuggestions"
    fi

    if [ ! -d "$custom_plugins/zsh-syntax-highlighting" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
            "$custom_plugins/zsh-syntax-highlighting"
    fi

    # Ensure .zshrc has the plugin list and source line (idempotent)
    append_once "$ZSHRC" 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)'
    append_once "$ZSHRC" 'source $HOME/.oh-my-zsh/oh-my-zsh.sh'

    success "ZSH + Oh My Zsh + plugins installed"
}

# ──────────────────────────────────────────────
# Module: go
# ──────────────────────────────────────────────
mod_go() {
    if command -v go &>/dev/null; then
        warn "Go already installed ($(go version)) — skipping"
        return 0
    fi

    info "Installing Go $GO_VERSION"
    local tarball="go${GO_VERSION}.linux-amd64.tar.gz"
    local download_dir="$SETUP_HOME/Downloads"

    ensure_dir "$download_dir"
    wget -q "https://go.dev/dl/${tarball}" -O "$download_dir/$tarball"

    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$download_dir/$tarball"
    rm -f "$download_dir/$tarball"

    # Persist PATH for Go binaries + GOPATH binaries
    append_once "$ZSHRC" 'export PATH="$PATH:/usr/local/go/bin"'
    append_once "$ZSHRC" 'export PATH="$PATH:$HOME/go/bin"'

    # Apply to current session too
    export PATH="$PATH:/usr/local/go/bin:$SETUP_HOME/go/bin"

    success "Go $GO_VERSION installed and PATH configured"
}

# ──────────────────────────────────────────────
# Module: copyq
# ──────────────────────────────────────────────
mod_copyq() {
    info "Configuring CopyQ clipboard manager"

    if ! command -v copyq &>/dev/null; then
        info "Installing CopyQ"
        sudo apt-get install -y copyq
    fi

    # Use a user-level systemd service instead of a system-level one.
    # This avoids hardcoding User/Group/DISPLAY and survives reboots cleanly.
    local user_service_dir="$SETUP_HOME/.config/systemd/user"
    ensure_dir "$user_service_dir"

    cat > "$user_service_dir/copyq.service" << EOF
[Unit]
Description=CopyQ Clipboard Manager
Documentation=man:copyq(1)
After=graphical-session.target

[Service]
ExecStart=/usr/bin/copyq
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF

    # Enable and start the user service
    run_as_user 'systemctl --user daemon-reload'
    run_as_user 'systemctl --user enable --now copyq.service'

    success "CopyQ configured as user service"
}

# ──────────────────────────────────────────────
# Module: autorecon
# ──────────────────────────────────────────────
mod_autorecon() {
    if command -v autorecon &>/dev/null; then
        warn "AutoRecon already installed — skipping"
        return 0
    fi

    info "Installing AutoRecon via pipx"
    python3 -m pip install --user pipx --break-system-packages 2>/dev/null \
        || pip3 install --user pipx --break-system-packages
    python3 -m pipx ensurepath
    pipx install git+https://github.com/Tib3rius/AutoRecon.git

    success "AutoRecon installed"
}

# ──────────────────────────────────────────────
# Module: aliases
# ──────────────────────────────────────────────
mod_aliases() {
    info "Setting up desktop directories, aliases, and helper functions"

    # Desktop directories
    ensure_dir "$SETUP_HOME/Desktop/tool"
    ensure_dir "$SETUP_HOME/Desktop/htb"
    ensure_dir "$SETUP_HOME/Desktop/assessment"

    # Decompress rockyou if still compressed
    if [ -f /usr/share/wordlists/rockyou.txt.gz ]; then
        sudo gunzip -d /usr/share/wordlists/rockyou.txt.gz
        info "Decompressed rockyou wordlist"
    fi

    # Ensure .local/bin exists
    ensure_dir "$SETUP_HOME/.local/bin"

    # Persist PATH
    append_once "$ZSHRC" 'export PATH="$HOME/.local/bin:$PATH"'

    # Aliases (idempotent — only add if not already present)
    append_once "$ZSHRC" 'alias assessment="cd $HOME/Desktop/assessment"'
    append_once "$ZSHRC" 'alias tool="cd $HOME/Desktop/tool"'
    append_once "$ZSHRC" 'alias aa="cd -"'
    append_once "$ZSHRC" 'alias htb="cd $HOME/Desktop/htb"'
    append_once "$ZSHRC" 'alias ipp="ip -4 -br a | grep -E '\''UP|UNKNOWN'\'' | grep -v '\''lo'\''; ipe"'
    append_once "$ZSHRC" 'alias hosts="sudo nano /etc/hosts"'
    append_once "$ZSHRC" 'alias mpd="mousepad"'
    append_once "$ZSHRC" 'alias up="echo '\'''\''; pwd; ls -la .; echo '\'''\''; (ip -br -4 a | grep -E '\''UP|UNKNOWN'\'') | grep -v '\''lo'\''; python3 -m http.server"'

    # Helper function: ipe — show public IP
    # Fixed: original had inverted logic (printed when empty) and non-POSIX ==
    if ! grep -q 'function ipe()' "$ZSHRC" 2>/dev/null; then
        cat >> "$ZSHRC" << 'IPE_EOF'

function ipe() {
    local grabIP
    grabIP=$(curl -4 -s icanhazip.com)
    if [ -n "$grabIP" ]; then
        echo "[+] $grabIP is your public IP"
    else
        echo "[!] Could not determine public IP"
    fi
}
IPE_EOF
    fi

    success "Aliases and helper functions configured"
}

# ──────────────────────────────────────────────
# Module: scripts
# ──────────────────────────────────────────────
mod_scripts() {
    info "Downloading additional scripts"

    local bin_dir="$SETUP_HOME/.local/bin"
    ensure_dir "$bin_dir"

    local scripts=("ffuf-gen.py" "nmap-parser.py")
    local failed=0

    for script in "${scripts[@]}"; do
        if wget -q "$SCRIPTS_REPO/$script" -O "$bin_dir/$script"; then
            chmod +x "$bin_dir/$script"
            success "Installed $script"
        else
            error "Failed to download $script"
            failed=1
        fi
    done

    if [ "$failed" -eq 0 ]; then
        success "All additional scripts installed"
    else
        warn "Some scripts failed to download"
    fi
}

# ──────────────────────────────────────────────
# Module registry
# ──────────────────────────────────────────────
declare -A MODULES=(
    [base]="apt update/upgrade, core packages, Sublime Text repo"
    [terminator]="Terminator terminal + Catppuccin profiles"
    [zsh]="Oh My Zsh + plugins (autosuggestions, syntax-highlighting)"
    [go]="Go $GO_VERSION toolchain"
    [copyq]="CopyQ clipboard manager (user systemd service)"
    [autorecon]="AutoRecon via pipx"
    [aliases]="Desktop dirs, shell aliases, helper functions, PATH"
    [scripts]="Additional scripts (ffuf-gen, nmap-parser)"
)

# Ordered list for 'all'
MODULE_ORDER=(base terminator zsh go copyq autorecon aliases scripts)

list_modules() {
    printf "\n${BLUE}QuickSetup v%s — Available Modules${NC}\n\n" "$VERSION"
    printf "  %-14s %s\n" "MODULE" "DESCRIPTION"
    printf "  %-14s %s\n" "──────" "───────────"
    for mod in "${MODULE_ORDER[@]}"; do
        printf "  %-14s %s\n" "$mod" "${MODULES[$mod]}"
    done
    printf "\n  %-14s %s\n" "all" "Run every module in order"
    printf "\n"
}

run_module() {
    local mod="$1"
    case "$mod" in
        base)       mod_base ;;
        terminator) mod_terminator ;;
        zsh)        mod_zsh ;;
        go)         mod_go ;;
        copyq)      mod_copyq ;;
        autorecon)  mod_autorecon ;;
        aliases)    mod_aliases ;;
        scripts)    mod_scripts ;;
        *)
            error "Unknown module: $mod"
            echo "Run '$0 list' to see available modules."
            exit 1
            ;;
    esac
}

usage() {
    cat << EOF
QuickSetup v$VERSION — Modular Kali Linux Quick Setup

Usage:
  $0 all               Run every module in order
  $0 <module> [...]    Run specific module(s)
  $0 list              List available modules
  $0 --help            Show this help

Modules: ${MODULE_ORDER[*]}
EOF
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
main() {
    if [ $# -eq 0 ]; then
        usage
        exit 1
    fi

    case "$1" in
        --help|-h)
            usage
            exit 0
            ;;
        list)
            list_modules
            exit 0
            ;;
        all)
            printf "${GREEN}[!] QuickSetup v%s — Full Setup${NC}\n\n" "$VERSION"
            for mod in "${MODULE_ORDER[@]}"; do
                run_module "$mod"
                echo
            done
            ;;
        *)
            printf "${GREEN}[!] QuickSetup v%s — Selective Setup${NC}\n\n" "$VERSION"
            for mod in "$@"; do
                run_module "$mod"
                echo
            done
            ;;
    esac

    printf "\n${GREEN}[+] QuickSetup complete!${NC}\n"
}

main "$@"
