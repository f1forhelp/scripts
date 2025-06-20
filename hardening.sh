#!/bin/bash
# Download and source the global script
GLOBAL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/global.sh > "$GLOBAL_SCRIPT"
. "$GLOBAL_SCRIPT"
rm "$GLOBAL_SCRIPT"

# Example usage
logk "i" "Starting hardening script... 2"
logk "s" "System check completed successfully"
logk "w" "Some settings may need manual review"
logk "e" "Failed to apply security policy"
logk "" "Failed to apply security policy"
