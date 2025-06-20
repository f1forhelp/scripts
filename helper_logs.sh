#!/bin/bash

# Pretty print logging function
logk() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "i")
            echo -e "\033[34m[INFO]\033[0m \033[90m$timestamp\033[0m $message"
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


# Example usage
# logk "info" "Starting hardening script..."
# logk "success" "System check completed successfully"
# logk "warning" "Some settings may need manual review"
# logk "error" "Failed to apply security policy"
# logk "" "Failed to apply security policy"
