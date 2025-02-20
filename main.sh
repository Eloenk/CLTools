#!/bin/bash

set -e

# Function to display graphical text
show_banner() {
    echo "\e[1;34m"
    echo "  ███████╗██╗      ██████╗ ███████╗███╗   ██╗    ██╗  ██╗ ██████╗  ██████╗██╗  ██╗"
    echo "  ██╔════╝██║     ██╔═══██╗██╔════╝████╗  ██║    ██║ ██║ ██╔═══██╗██╔════╝██║  ██║"
    echo "  █████╗  ██║     ██║   ██║█████╗  ██╔██╗ ██║    █████║  ██║   ██║██║     ███████║"
    echo "  ██╔══╝  ██║     ██║   ██║██╔══╝  ██║╚██╗██║    ██╔═██║ ██║   ██║██║     ██╔══██║"
    echo "  ███████ ███████╗╚██████╔╝███████╗██║ ╚████║    ██║  ██║╚██████╔╝╚██████╗██║  ██║"
    echo "  ╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝"
    echo "\e[0m"
}

# Detect OS
ios=$(grep -E '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

# Install Development Tools
install_dev_tools() {
    show_banner
    echo "Installing Development Tools..."
    sudo apt-get update -y
    sudo apt-get install -y build-essential git curl wget jq tmux screen libssl-dev unzip pkg-config
}

# Install Go
install_go() {
    show_banner
    echo "Installing Go..."
    latest_go=$(curl -s https://go.dev/VERSION?m=text | sed -n '1p')
    wget https://go.dev/dl/${latest_go}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf ${latest_go}.linux-amd64.tar.gz
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    source ~/.bashrc
    rm ${latest_go}.linux-amd64.tar.gz
}

# Install Docker
install_docker() {
    show_banner
    echo "Installing Docker..."
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/${ios}/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/${ios} $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
}

# Install Node.js
install_node() {
    show_banner
    echo "Installing Node.js..."
    valu=$(curl -sL https://nodejs.org/dist/index.tab | awk '{print $1}' | grep -Eo '^v[0-9]+' | head -1 | tr -d 'v')
    curl -o- https://fnm.vercel.app/install | bash
    fnm install ${valu}

}
install_rust() {
    if ! command -v rustc >/dev/null 2>&1; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    export PATH="$HOME/.cargo/bin:$PATH"
    source "$HOME/.cargo/env"
    echo "Rust installed: $(rustc --version)"
    else
    echo "Rust is already installed: $(rustc --version)"
    fi
    curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip
    unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local
    export PATH="$HOME/.local/bin:$PATH"

}

# Install everything
install_dev_tools
install_rust
install_go
install_docker
install_node

echo "Installation completed. Restart your terminal or run 'source ~/.bashrc' to apply changes."
