#!/bin/bash

# Function to append a line to the end of a file
# Usage: append_line_to_file <file_path> <line_to_append>
# Parameters:
#   $1 - file path (required)
#   $2 - line to append (required, can contain special characters and quotes)
append_line_to_end() {
    # Check if correct number of arguments are provided
    if [ $# -ne 2 ]; then
        echo "Error: append_line_to_file requires exactly 2 arguments"
        echo "Usage: append_line_to_file <file_path> <line_to_append>"
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
    
    # Check if file exists, if not create it
    if [ ! -f "$file_path" ]; then
        touch "$file_path"
        echo "Created new file: $file_path"
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
