#!/bin/bash

# ---- Available Options ----
install_netbird(){
    logk "i" "Installing netbird"
    curl -fsSL https://pkgs.netbird.io/install.sh | sh
    netbird up
    logk "i" "Netbird installed"
    sudo systemctl enable --now netbird
    sudo systemctl status netbird
}

install_netbird_with_ssh(){
    logk "i" "Installing netbird with ssh"
    curl -fsSL https://pkgs.netbird.io/install.sh | sh
    netbird up --allow-server-ssh
    logk "i" "Netbird installed"
    sudo systemctl enable --now netbird
    sudo systemctl status netbird
}

script_netbird(){
    logk "i" "Select the option for netbird"
    loge "1. Install netbird"
    loge "2. Install netbird with ssh"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_netbird ;;
        2) install_netbird_with_ssh ;;
        *) logk "e" "Invalid choice" ;;
    esac
}