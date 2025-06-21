#!/bin/bash
# Download and source the global script
GLOBAL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/global.sh > "$GLOBAL_SCRIPT"
. "$GLOBAL_SCRIPT"
rm "$GLOBAL_SCRIPT"

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
    logk "i" "Allowing ssh"
    sudo ufw allow ssh
}

allow_postgresql(){
    logk "i" "Allowing postgresql"
    sudo ufw allow 5432/tcp
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
    logk "i" "Disabling ssh"
    sudo ufw delete allow ssh
}

disable_postgresql() {
    logk "i" "Disabling postgresql"
    sudo ufw delete allow 5432/tcp
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

ufw_options() {
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





# Main script execution
ufw_options


