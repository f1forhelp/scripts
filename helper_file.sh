#!/bin/bash

# Function to append a line to the end of a file
# Usage: append_line_to_end <file_path> <line_to_append>
# Parameters:
#   $1 - file path (required)
#   $2 - line to append (required, can contain special characters and quotes)
append_line_to_end() {
    # Check if correct number of arguments are provided
    if [ $# -ne 2 ]; then
        echo "Error: append_line_to_end requires exactly 2 arguments"
        echo "Usage: append_line_to_end <file_path> <line_to_append>"
        return 1
    fi
    
    local file_path="$1"
    local line_to_append="$2"
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        echo "Error: File path cannot be empty"
        return 1
    fi
    
    # Check if line to append is provided
    if [ -z "$line_to_append" ]; then
        echo "Error: Line to append cannot be empty"
        return 1
    fi
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: File does not exist: $file_path"
        return 1
    fi
    
    # Append the line to the file using printf to handle special characters properly
    printf '%s\n' "$line_to_append" >> "$file_path"
    
    if [ $? -eq 0 ]; then
        echo "Successfully appended line to: $file_path"
        return 0
    else
        echo "Error: Failed to append line to: $file_path"
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
        echo "Error: append_line_to_beginning requires exactly 2 arguments"
        echo "Usage: append_line_to_beginning <file_path> <line_to_append>"
        return 1
    fi
    
    local file_path="$1"
    local line_to_append="$2"
    local temp_file
    
    # Check if file path is provided
    if [ -z "$file_path" ]; then
        echo "Error: File path cannot be empty"
        return 1
    fi
    
    # Check if line to append is provided
    if [ -z "$line_to_append" ]; then
        echo "Error: Line to append cannot be empty"
        return 1
    fi
    
    # Check if file exists
    if [ ! -f "$file_path" ]; then
        echo "Error: File does not exist: $file_path"
        return 1
    fi
    
    # Create a temporary file
    temp_file=$(mktemp)
    
    # Write the new line to the beginning of temp file
    printf '%s\n' "$line_to_append" > "$temp_file"
    
    # Append the original file content to temp file
    cat "$file_path" >> "$temp_file"
    
    # Replace the original file with the temp file
    if mv "$temp_file" "$file_path"; then
        echo "Successfully appended line to beginning of: $file_path"
        return 0
    else
        echo "Error: Failed to append line to beginning of: $file_path"
        # Clean up temp file if move failed
        rm -f "$temp_file"
        return 1
    fi
}
