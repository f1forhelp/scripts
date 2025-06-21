#!/bin/bash

readonly VERSION="0.0.17"

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


FIREWALL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_firewall.sh > "$FIREWALL_SCRIPT"
. "$FIREWALL_SCRIPT"
rm "$FIREWALL_SCRIPT"

HARDENING_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_hardening.sh > "$HARDENING_SCRIPT"
. "$HARDENING_SCRIPT"
rm "$HARDENING_SCRIPT"

logk "s" "v$VERSION"
loge ""

logk "i" "Select below options"
loge "1. Firewall"
loge "2. Hardening"
read -p "Enter the option: " option

case $option in
    1) script_firewall ;;
    2) script_hardening ;;
esac