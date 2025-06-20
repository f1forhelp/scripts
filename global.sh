#!/bin/bash

# Global script for sourcing remote helper functions
# Downloads and sources the helper_logs.sh script from remote repository

# Download and source the helper script
TEMP_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_logs.sh > "$TEMP_SCRIPT"
. "$TEMP_SCRIPT"
rm "$TEMP_SCRIPT" 