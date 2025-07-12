#!/bin/bash

# Function to append a line to the end of a file
# Usage: append_line_to_end <file_path> <line_to_append>
# Parameters:
#   $1 - file path (required)
#   $2 - line to append (required, can contain special characters and quotes)
append_line_to_end() {
    # Check if correct number of arguments are provided
    if [ $# -ne 2 ]; then
        logk "e" "append_line_to_end requires exactly 2 arguments"
        logk "e" "Usage: append_line_to_end <file_path> <line_to_append>"
        return 1
    fi
    
    local file_path="$1"
    local line_to_append="$2"
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        logk "e" "File path cannot be empty"
        return 1
    fi
    
    # Check if line to append is provided
    if [ -z "$line_to_append" ]; then
        logk "e" "Line to append cannot be empty"
        return 1
    fi
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        logk "e" "File does not exist: $file_path"
        return 1
    fi
    
    # Append the line to the file using printf to handle special characters properly
    sudo printf '%s\n' "$line_to_append" >> "$file_path"
    
    if [ $? -eq 0 ]; then
        logk "i" "Successfully appended line to: $file_path"
        return 0
    else
        logk "e" "Failed to append line to: $file_path"
        return 1
    fi
}

# Function to append a line at the beginning of a file
# Usage: append_line_to_beginning <file_path> <line_to_append>
# Parameters:
#   $1 - file path (required)
#   $2 - line to append (required, can contain special characters and quotes)
append_line_to_start() {
    # Check if correct number of arguments are provided
    if [ $# -ne 2 ]; then
        logk "e" "append_line_to_beginning requires exactly 2 arguments"
        logk "e" "Usage: append_line_to_beginning <file_path> <line_to_append>"
        return 1
    fi
    
    local file_path="$1"
    local line_to_append="$2"
    local temp_file
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        logk "e" "File path cannot be empty"
        return 1
    fi
    
    # Check if line to append is provided
    if [ -z "$line_to_append" ]; then
        logk "e" "Line to append cannot be empty"
        return 1
    fi
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        logk "e" "File does not exist: $file_path"
        return 1
    fi
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Write the new line to the beginning of temp file
    sudo printf '%s\n' "$line_to_append" > "$temp_file"
    
    # Append the original file content to temp file
    sudo cat "$file_path" >> "$temp_file"
    
    # Replace the original file with the temp file
    if sudo mv "$temp_file" "$file_path"; then
        logk "i" "Successfully appended line to beginning of: $file_path"
        return 0
    else
        logk "e" "Failed to append line to beginning of: $file_path"
        # Clean up temp file if move failed
        sudo rm -f "$temp_file"
        return 1
    fi
}

backup_file() {
    local file_path="$1"
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        logk "e" "File path cannot be empty"
        return 1
    fi
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        logk "e" "File does not exist: $file_path"
        return 1
    fi
    
    # Find the next available backup number
    local backup_number=1
    while [ -f "${file_path}.bak${backup_number}" ]; do
        ((backup_number++))
    done
    
    local backup_path="${file_path}.bak${backup_number}"
    sudo cp "$file_path" "$backup_path"
    
    if [ $? -eq 0 ]; then
        logk "i" "Successfully backed up: $file_path to $backup_path"
        return 0
    else
        logk "e" "Failed to backup: $file_path"
        return 1
    fi
}

restore_file() {
    local file_path="$1"
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        logk "e" "File path cannot be empty"
        return 1
    fi
    
    # Find the highest backup number
    local highest_backup=0
    local backup_path=""
    
    # Check for existing backups
    for backup in "${file_path}.bak"*; do
        if [ -f "$backup" ]; then
            # Extract the number from the backup filename
            local backup_num=$(echo "$backup" | sed "s|${file_path}\.bak||")
            if [ "$backup_num" -gt "$highest_backup" ]; then
                highest_backup=$backup_num
                backup_path="$backup"
            fi
        fi
    done
    
    # Check if any backup was found
    if [ "$highest_backup" -eq 0 ]; then
        logk "e" "No backup found for: $file_path"
        return 1
    fi
    
    # Restore from the latest backup
    sudo cp "$backup_path" "$file_path"
    
    if [ $? -eq 0 ]; then
        logk "i" "Successfully restored: $file_path from $backup_path"
        # Remove the backup file that was just used
        sudo rm "$backup_path"
        logk "i" "Removed backup: $backup_path"
        return 0
    else
        logk "e" "Failed to restore: $file_path from $backup_path"
        return 1
    fi
}