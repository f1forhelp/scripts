#!/bin/bash

# Function to create user and add to sudo group
create_user_with_sudo() {
    local username="$1"
    
    # Check if username is provided
    if [[ -z "$username" ]]; then
        logk "e" "Username is required"
        return 1
    fi
    
    # Check if user already exists
    if id "$username" &>/dev/null; then
        logk "w" "User '$username' already exists"
        return 0
    else
        # Create the user
        logk "i" "Creating user '$username'..."
        useradd -m -s /bin/bash "$username"
        
        if [[ $? -eq 0 ]]; then
            logk "s" "User '$username' created successfully"
        else
            logk "e" "Failed to create user '$username'"
            return 1
        fi
    fi
    
    # Add user to sudo group
    logk "i" "Adding user '$username' to sudo group..."
    usermod -aG sudo "$username"
    
    if [[ $? -eq 0 ]]; then
        logk "s" "User '$username' added to sudo group successfully"
    else
        logk "e" "Failed to add user '$username' to sudo group"
        return 1
    fi
    
    # Set password for the user
    logk "i" "Setting password for user '$username'..."
    passwd "$username"
    
    logk "s" "User setup completed for '$username'"
}

copy_ssh_key(){
    local username="$1"
    local ssh_key="$2"
    
    # Check if username is provided
    if [[ -z "$username" ]]; then
        logk "e" "Username is required"
        return 1
    fi
    
    # Check if ssh_key is provided
    if [[ -z "$ssh_key" ]]; then
        logk "e" "SSH key is required"
        return 1
    fi
    
    # Copy the ssh key to the user's home directory
    logk "i" "Copying SSH key to user '$username'..."
    mkdir -p "/home/$username/.ssh"
    cat "$ssh_key" > "/home/$username/.ssh/authorized_keys"
    chmod 600 "/home/$username/.ssh/authorized_keys"
    chown -R "$username:$username" "/home/$username/.ssh"
    
    logk "s" "SSH key copied to user '$username' successfully"
}


change_sshd_config(){
    logk "i" "SSHD config change"
    read -p "Enter the port number for ssh or press enter to use default (22): " ssh_port
    if [ -z "$ssh_port" ]; then
        ssh_port=22
    fi


    loge ""
    logk "i" "SSHD config before change"
    sudo sshd -T | grep permitrootlogin
    sudo sshd -T | grep passwordauthentication
    sudo sshd -T | grep pubkeyauthentication
    sudo sshd -T | grep permituserenvironment
    sudo sshd -T | grep permittunnel
    sudo sshd -T | grep port
    append_line_to_start "/etc/ssh/sshd_config" "PermitRootLogin no"
    append_line_to_start "/etc/ssh/sshd_config" "PasswordAuthentication no"
    append_line_to_start "/etc/ssh/sshd_config" "PubkeyAuthentication yes"
    append_line_to_start "/etc/ssh/sshd_config" "PermitUserEnvironment no"
    append_line_to_start "/etc/ssh/sshd_config" "PermitTunnel no"
    append_line_to_start "/etc/ssh/sshd_config" "Port $ssh_port"
    sudo systemctl restart sshd
    loge ""
    logk "i" "SSHD config after change"
    sudo sshd -T | grep permitrootlogin
    sudo sshd -T | grep passwordauthentication
    sudo sshd -T | grep pubkeyauthentication
    sudo sshd -T | grep permituserenvironment
    sudo sshd -T | grep permittunnel
    sudo sshd -T | grep port
    logk "i" "Verify the sshd config above and press any key to continue"
    read -n 1 -s
}

install_fail2ban(){
    logk "i" "Installing fail2ban..."
    sudo apt-get install -y fail2ban
    # sudo systemctl enable fail2ban
    # sudo systemctl start fail2ban
    sudo systemctl enable --now fail2ban
    sudo systemctl status fail2ban
    logk "i" "Fail2ban installed and enabled"
}


switch_to_user(){
    local username="$1"
    logk "i" "Switching to user '$username'..."
    sudo su - "$username"
}

system_update(){
    logk "i" "Updating system..."
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get dist-upgrade -y
    sudo apt-get autoremove -y
}

script_hardening_one(){
 
    # Main script execution
    logk "i" "Starting hardening script one..."

    # Get username from user input
    logk "i" "Enter the username to create:"
    read -r username

    # Create user with sudo privileges
    create_user_with_sudo "$username"

    # Copy the ssh key to the user's home directory
    copy_ssh_key "$username" "/root/.ssh/authorized_keys"

    # Switch to user
    switch_to_user "$username"



    logk "i" "Hardening script completed"
   
}

script_hardening_two(){
    logk "i" "Starting hardening script two..."

    # Update system
    system_update

    # Change the sshd config
    change_sshd_config

    # Install fail2ban
    install_fail2ban

    # Install ufw
    script_firewall

    logk "i" "Hardening script two completed"
   
}

script_system_update(){
    logk "i" "Updating system..."
    system_update
}