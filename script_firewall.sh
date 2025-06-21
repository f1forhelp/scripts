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
    enable_ufw
    reload_ufw
    ufw_status
}

allow_default_incoming() {
    logk "i" "Allowing default incoming"
    ufw allow incoming
}

allow_default_outgoing() {
    logk "i" "Allowing default outgoing"
    ufw allow outgoing
}

allow_default_incoming_and_outgoing() {
    allow_default_incoming
    allow_default_outgoing
}

allow_ssh(){
    logk "i" "Allowing ssh"
    ufw allow ssh
}

allow_postgresql(){
    logk "i" "Allowing postgresql"
    ufw allow 5432/tcp
}

disable_default_incoming() {
    logk "i" "Disabling default incoming"
    ufw default deny incoming
}

disable_default_outgoing() {
    logk "i" "Disabling default outgoing"
    ufw default deny outgoing
}

disable_default_incoming_and_outgoing() {
    disable_default_incoming
    disable_default_outgoing
}

disable_ssh() {
    logk "i" "Disabling ssh"
    ufw delete allow ssh
}

disable_postgresql() {
    logk "i" "Disabling postgresql"
    ufw delete allow 5432/tcp
}

reload_ufw() {
    logk "i" "Reloading ufw"
    ufw reload
}

ufw_status() {
    logk "i" "Ufw status"
    ufw status
    systemctl status ufw
}



# ---- Functions ----
install_ufw() {
    logk "i" "Installing ufw..."
    apt-get install -y ufw
    enable_ufw
}

enable_ufw() {
    logk "i" "Enabling ufw..."
    ufw enable
    systemctl enable ufw
    systemctl start ufw
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
    loge "13. Exit"

    read -p "Enter the option: " option
    # case $option in
}





# Main script execution
ufw_options


