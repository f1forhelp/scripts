#!/bin/bash

# Pretty print logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "info")
            echo -e "\033[34m[INFO]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "success")
            echo -e "\033[32m[SUCCESS]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "warning")
            echo -e "\033[33m[WARNING]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        "error")
            echo -e "\033[31m[ERROR]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
        *)
            echo -e "\033[37m[LOG]\033[0m \033[90m$timestamp\033[0m $message"
            ;;
    esac
}


# Example usage
log "info" "Starting hardening script..."
log "success" "System check completed successfully"
log "warning" "Some settings may need manual review"
log "error" "Failed to apply security policy"
log "" "Failed to apply security policy"
