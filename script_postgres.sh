#!/bin/bash
readonly configRootPathPG17="/etc/postgresql/17/main"
readonly configPgHbaPathPG17="$configRootPathPG17/pg_hba.conf"
readonly configPgConfPathPG17="$configRootPathPG17/postgresql.conf"


# ------ Options ------

install_postgres-v17() {
    logk "i" "Installing postgres-v17..."
    sudo apt install -y postgresql-common
    sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
    sudo apt-get install -y postgresql-17
    logk "i" "Postgres-v17 installed"
    enable_postgres-v17
}

# TODO: Implement uninstall_postgres-v17
uninstall_postgres-v17() {
    logk "i" "TODO: Uninstalling postgres-v17..."
}

configure_postgres-v17() {
    logk "i" "Configuring postgres-v17..."
    backup_file "$configPgHbaPathPG17"
    backup_file "$configPgConfPathPG17"
    logk "i" "Configuring pg_hba.conf..."
    read -p "Enter the private IP CIDR: " privateIpCidr
    append_line_to_end "$configPgHbaPathPG17" "host    all             all             $privateIpCidr           scram-sha-256"
    logk "i" "Configuring postgresql.conf..."
    configure_listen_addresses
    logk "i" "Postgres-v17 configured"
}

reset_postgres-v17-config() {
    logk "i" "Resetting postgres-v17..."
    restore_file "$configPgHbaPathPG17"
    restore_file "$configPgConfPathPG17"
    # sudo systemctl stop postgresql@17-main
    # sudo systemctl disable postgresql@17-main
    # sudo rm -rf /var/lib/postgresql/17/main
    logk "i" "Postgres-v17 reset"
}

hardening_postgres-v17() {
    logk "i" "Hardening postgres-v17..."
    read -p "Enter Db Username: " dbUsername
    read -p "Enter Db Password: " password
    read -p "Enter Db Name: " dbName
    sudo -u postgres psql -c "CREATE USER $dbUsername WITH PASSWORD '$password';"
    sudo -u postgres psql -c "CREATE DATABASE $dbName;"
    sudo -u postgres psql -c "ALTER ROLE $dbUsername WITH SUPERUSER;"
    sudo -u postgres psql -c "ALTER USER postgres NOLOGIN;"

    logk "i" "Hardening postgres-v17 completed"
        
}

# ------ Functions ------
enable_postgres-v17() {
    logk "i" "Enabling postgres-v17..."
    sudo systemctl enable --now postgresql@17-main
    sudo systemctl status postgresql@17-main
    logk "i" "Postgres-v17 enabled"
}

configure_listen_addresses() {
    logk "i" "Enter option for listen_address"
    loge "1. localhost"
    loge "2. publicIP"
    loge "3. privateIP"
    loge "4. all"
    read -p "Enter your choice: " choice
    case $choice in
        1) append_line_to_start "$configPgConfPathPG17" "listen_addresses = 'localhost'" ;;
        2) append_line_to_start "$configPgConfPathPG17" "listen_addresses = '$(get_public_ip_v4)'" ;;
        3) append_line_to_start "$configPgConfPathPG17" "listen_addresses = '$(get_private_ip)'" ;;
        4) append_line_to_start "$configPgConfPathPG17" "listen_addresses = '*'" ;;
        *) logk "e" "Invalid choice" ;;
    esac
    logk "i" "listen_addresses configured"
}


# ------ Script ------
script_postgres() {
    logk "i" "Select the option for postgres"
    loge "1. Install postgres-v17"
    loge "2. Uninstall postgres-v17"
    loge "3. Configure postgres-v17"
    loge "4. Reset postgres-v17-config"
    loge "5. Hardening postgres-v17"
    loge "6. Update system"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_postgres-v17 ;;
        2) uninstall_postgres-v17 ;;
        3) configure_postgres-v17 ;;
        4) reset_postgres-v17-config ;;
        5) hardening_postgres-v17 ;;
        5) script_system_update ;;
        *) logk "e" "Invalid choice" ;;
    esac
}


# Imp commands

# to check cluster status
# sudo pg_lsclusters 