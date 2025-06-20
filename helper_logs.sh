#!/bin/bash

# Pretty print logging function
logk() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "i")
            echo -e "\033[36m[INFO]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "s")
            echo -e "\033[32m[SUCCESS]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "w")
            echo -e "\033[33m[WARNING]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "e")
            echo -e "\033[31m[ERROR]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        *)
            echo -e "\033[37m[LOG]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
    esac
}

logs(){
    local message="$*"
    echo -e "$message"
}


# Example usage
# logk "i" "Starting hardening script..."
# logk "s" "System check completed successfully"
# logk "w" "Some settings may need manual review"
# logk "e" "Failed to apply security policy"
# logk "" "Failed to apply security policy"
