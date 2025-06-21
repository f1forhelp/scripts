#!/bin/bash

# ---- Available Options ----
fresh_install() {
    install_ufw
    disable_default_incoming_and_outgoing
    allow_ssh
    reload_ufw
    ufw_status
}

allow_default_incoming() {
    logk "i" "Allowing default incoming"
    sudo ufw allow incoming
}

allow_default_outgoing() {
    logk "i" "Allowing default outgoing"
    sudo ufw allow outgoing
}

allow_default_incoming_and_outgoing() {
    allow_default_incoming
    allow_default_outgoing
}

allow_ssh(){
    loge ""
    logk "i" "Enter the port number for ssh or press enter to use default (22)"
    read -r ssh_port
    if [ -z "$ssh_port" ]; then
        ssh_port=22
    fi
    logk "i" "Allowing ssh on port $ssh_port"
    sudo ufw allow $ssh_port/tcp
}

allow_postgresql(){
    loge ""
    logk "i" "Enter the port number for postgresql or press enter to use default (5432)"
    read -r postgresql_port
    if [ -z "$postgresql_port" ]; then
        postgresql_port=5432
    fi
    logk "i" "Allowing postgresql on port $postgresql_port"
    sudo ufw allow $postgresql_port/tcp
}

disable_default_incoming() {
    logk "i" "Disabling default incoming"
    sudo ufw default deny incoming
}

disable_default_outgoing() {
    logk "i" "Disabling default outgoing"
    sudo ufw default deny outgoing
}

disable_default_incoming_and_outgoing() {
    disable_default_incoming
    disable_default_outgoing
}

disable_ssh() {
    loge ""
    logk "i" "Enter the port number for ssh or press enter to use default (22)"
    read -r ssh_port
    if [ -z "$ssh_port" ]; then
        ssh_port=22
    fi
    logk "i" "Disabling ssh on port $ssh_port"
    sudo ufw delete allow $ssh_port/tcp
}

disable_postgresql() {
    loge ""
    logk "i" "Enter the port number for postgresql or press enter to use default (5432)"
    read -r postgresql_port
    if [ -z "$postgresql_port" ]; then
        postgresql_port=5432
    fi
    logk "i" "Disabling postgresql on port $postgresql_port"
    sudo ufw delete allow $postgresql_port/tcp
}

reload_ufw() {
    logk "i" "Reloading ufw"
    sudo ufw reload
}

ufw_status() {
    logk "i" "Ufw status"
    sudo ufw status
    sudo systemctl status ufw
}



# ---- Functions ----
install_ufw() {
    logk "i" "Installing ufw..."
    sudo apt-get install -y ufw
    enable_ufw
}

enable_ufw() {
    logk "i" "Enabling ufw..."
    sudo ufw enable
    sudo systemctl enable ufw
    sudo systemctl start ufw
    ufw_status
}

script_firewall() {
    logk "i" "Select the option for ufw"
    loge "1. Fresh System install"
    loge "2. Allow default incoming"
    loge "3. Allow default outgoing"
    loge "4. Allow default incoming and outgoing"
    loge "5. Allow ssh"
    loge "6. Allow postgresql"
    loge "7. Disable default incoming"
    loge "8. Disable default outgoing"
    loge "9. Disable default incoming and outgoing"
    loge "10. Disable ssh"
    loge "11. Disable postgresql"
    loge "12. Reload ufw"
    loge "13. Ufw status"
    loge "14. Exit"

    read -p "Enter the option: " option
    case $option in
        1) fresh_install ;;
        2) allow_default_incoming ;;
        3) allow_default_outgoing ;;
        4) allow_default_incoming_and_outgoing ;;
        5) allow_ssh ;;
        6) allow_postgresql ;;
        7) disable_default_incoming ;;
        8) disable_default_outgoing ;;
        9) disable_default_incoming_and_outgoing ;;
        10) disable_ssh ;;
        11) disable_postgresql ;;
        12) reload_ufw ;;
        13) ufw_status ;;
        14) exit ;;
    esac
    
}


