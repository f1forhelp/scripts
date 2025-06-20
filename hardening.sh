#!/bin/bash
echo "Starting hardening script... 1"
# Pretty print logging function
source <(curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_logs.sh)

# Example usage
logk "info" "Starting hardening script... 1"
logk "success" "System check completed successfully"
logk "warning" "Some settings may need manual review"
logk "error" "Failed to apply security policy"
logk "" "Failed to apply security policy"
