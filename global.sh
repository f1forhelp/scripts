#!/bin/bash

# Global script for sourcing remote helper functions
# Downloads and sources the helper_logs.sh script from remote repository

# Download and source the helper script
HELPER_LOGS=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_logs.sh > "$HELPER_LOGS"
. "$HELPER_LOGS"
rm "$HELPER_LOGS" 

# Download and source the helper script
HELPER_USER=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_user.sh > "$HELPER_USER"
. "$HELPER_USER"
rm "$HELPER_USER" 

# Download and source the helper script
HELPER_FILE=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_file.sh > "$HELPER_FILE"
. "$HELPER_FILE"
rm "$HELPER_FILE" 


# Log the version of the script
logk "i" "v0.0.11"