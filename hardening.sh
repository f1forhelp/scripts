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

# Main script execution
logk "i" "Starting hardening script..."

# Get username from user input
echo "Enter the username to create:"
read -r username

# Create user with sudo privileges
create_user_with_sudo "$username"

logk "i" "Hardening script completed"

