#!/bin/bash

# Global script for sourcing remote helper functions
# Downloads and sources the helper_logs.sh script from remote repository

# Download and source the helper script
HELPER_LOGS=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_logs.sh > "$HELPER_LOGS"
. "$HELPER_LOGS"
rm "$HELPER_LOGS" 

logk "i" "v0.0.2"