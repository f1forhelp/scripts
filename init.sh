#!/bin/bash

readonly VERSION="0.0.31"   

# Download and source the helper script
HELPER_LOGS=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_logs.sh > "$HELPER_LOGS"
. "$HELPER_LOGS"
rm "$HELPER_LOGS" 

# Download and source the helper script
HELPER_IP=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/helper_ip.sh > "$HELPER_IP"
. "$HELPER_IP"
rm "$HELPER_IP" 

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

# Download and source the firewall script
FIREWALL_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_firewall.sh > "$FIREWALL_SCRIPT"
. "$FIREWALL_SCRIPT"
rm "$FIREWALL_SCRIPT"


HARDENING_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_hardening.sh > "$HARDENING_SCRIPT"
. "$HARDENING_SCRIPT"
rm "$HARDENING_SCRIPT"

POSTGRES_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_postgres.sh > "$POSTGRES_SCRIPT"
. "$POSTGRES_SCRIPT"
rm "$POSTGRES_SCRIPT"

NETBIRD_SCRIPT=$(mktemp)
curl -s https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/script_netbird.sh > "$NETBIRD_SCRIPT"
. "$NETBIRD_SCRIPT"
rm "$NETBIRD_SCRIPT"

logk "s" "v$VERSION"
loge ""

logk "i" "Select below options (Remember to run as non root user except Hardening One)"
loge "1. Hardening One"
loge "2. Hardening Two"
loge "3. Netbird"
loge "4. Firewall"
loge "5. Postgres"
read -p "Enter the option: " option

case $option in
    1) script_hardening_one ;;
    2) script_hardening_two ;;
    3) script_netbird ;;
    4) script_firewall ;;
    5) script_postgres ;;
esac