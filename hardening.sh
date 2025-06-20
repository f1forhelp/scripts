#!/bin/bash
echo "Starting hardening script... 6"
# Pretty print logging function
# Download and source the helper script
GLOBAL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/global.sh > "$GLOBAL_SCRIPT"
. "$GLOBAL_SCRIPT"
rm "$GLOBAL_SCRIPT"

# Example usage
logk "info" "Starting hardening script... 1"
logk "success" "System check completed successfully"
logk "warning" "Some settings may need manual review"
logk "error" "Failed to apply security policy"
logk "" "Failed to apply security policy"
