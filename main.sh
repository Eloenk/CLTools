#!/bin/bash

set -e

# Function to display graphical text
show_banner() {
    echo "\e[1;34m"
    echo "  ███████╗██╗      ██████╗ ███████╗███╗   ██╗    ██╗  ██╗ ██████╗  ██████╗██╗  ██╗"
    echo "  ██╔════╝██║     ██╔═══██╗██╔════╝████╗  ██║    ██║  ██║██╔═══██╗██╔════╝██║  ██║"
    echo "  █████╗  ██║     ██║   ██║█████╗  ██╔██╗ ██║    ███████║██║   ██║██║     ███████║"
    echo "  ██╔══╝  ██║     ██║   ██║██╔══╝  ██║╚██╗██║    ██╔══██║██║   ██║██║     ██╔══██║"
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
    sudo apt-get install -y build-essential git curl wget jq tmux screen libssl-dev
}

# Install Go
install_go() {
    show_banner
    echo "Installing Go..."
    latest_go=$(curl -s https://go.dev/VERSION?m=text | cut -d' ' -f1)
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
    latest_node=$(curl -sL https://nodejs.org/dist/index.tab | awk '{print $1}' | grep -E '^v[0-9]+' | head -1 | tr -d 'v')
    curl -fsSL https://deb.nodesource.com/setup_${latest_node}.x | sudo -E bash -
    sudo apt-get install -y nodejs

}

# Install everything
install_dev_tools
install_go
install_docker
install_node

echo "Installation completed. Restart your terminal or run 'source ~/.bashrc' to apply changes."
