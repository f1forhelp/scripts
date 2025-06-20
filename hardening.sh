#!/bin/bash
# Download and source the global script
GLOBAL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/global.sh > "$GLOBAL_SCRIPT"
. "$GLOBAL_SCRIPT"
rm "$GLOBAL_SCRIPT"

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

# Main script execution
logk "i" "Starting hardening script..."

# Get username from user input
echo "Enter the username to create:"
read -r username

# Create user with sudo privileges
create_user_with_sudo "$username"

# Copy the ssh key to the user's home directory
copy_ssh_key "$username" "/root/.ssh/authorized_keys"


logk "i" "Hardening script completed"

