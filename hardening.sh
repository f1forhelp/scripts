#!/bin/bash

# Pretty print logging function
source <(curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/hardening.sh)

# Example usage
log "info" "Starting hardening script..."
log "success" "System check completed successfully"
log "warning" "Some settings may need manual review"
log "error" "Failed to apply security policy"
log "" "Failed to apply security policy"
