#!/bin/bash


prompt_set_password() {
    local username="$1"
    logk "i" "Setting password for user '$username'..."
    if [[ -z "$username" ]]; then
        logk "e" "Username is required"
        return 1
    fi
    
    # Prompt for password and set it
    echo "Enter password for user '$username':"
    passwd "$username"
    
    if [[ $? -eq 0 ]]; then
        logk "s" "Password set successfully for user '$username'"
    else
        logk "e" "Failed to set password for user '$username'"
        return 1
    fi
}

add_user() {
    local username="$1"
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
}

add_user_to_sudo_group() {
    local username="$1"
    # Add user to sudo group
    logk "i" "Adding user '$username' to sudo group..."
    usermod -aG sudo "$username"
}

add_user_to_postgres_group() {
    local username="$1"
    # Add user to postgres group    
    usermod -aG postgres "$username"
    logk "i" "User '$username' added to postgres group"
}