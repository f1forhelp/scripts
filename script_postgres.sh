#!/bin/bash



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

configure_postgres-v17-master() {    
    logk "i" "Configuring postgres-v17..."
    backup_file "$K_CONFIG_PG_HBA_PATH_PG17"
    backup_file "$K_CONFIG_PG_CONF_PATH_PG17"
    remove_all_comments "$K_CONFIG_PG_HBA_PATH_PG17"
    remove_all_comments "$K_CONFIG_PG_CONF_PATH_PG17"
    logk "i" "Configuring pg_hba.conf..."
    read -p "Enter the private IP CIDR: " privateIpCidr
    append_line_to_end "$K_CONFIG_PG_HBA_PATH_PG17" "$K_ADDED_BY_ADMIN"
    append_line_to_end "$K_CONFIG_PG_HBA_PATH_PG17" "host    all             all             $privateIpCidr           scram-sha-256"
    prompt_edit_file "$K_CONFIG_PG_HBA_PATH_PG17"
    logk "i" "Configuring postgresql.conf..."
    configure_listen_addresses
    prompt_edit_file "$K_CONFIG_PG_CONF_PATH_PG17"
    logk "i" "Setting permissions for pg_hba.conf and postgresql.conf..."
    sudo chmod 640 "$K_CONFIG_PG_HBA_PATH_PG17"
    sudo chmod 640 "$K_CONFIG_PG_CONF_PATH_PG17"
    sudo chown postgres:postgres "$K_CONFIG_PG_HBA_PATH_PG17"
    sudo chown postgres:postgres "$K_CONFIG_PG_CONF_PATH_PG17"
    restart_postgres-v17
    logk "i" "Postgres-v17 configured"
}

reset_postgres-v17-config() {
    logk "i" "Resetting postgres-v17..."
    restore_file "$K_CONFIG_PG_HBA_PATH_PG17"
    restore_file "$K_CONFIG_PG_CONF_PATH_PG17"
    # sudo systemctl stop postgresql@17-main
    # sudo systemctl disable postgresql@17-main
    # sudo rm -rf /var/lib/postgresql/17/main
    logk "i" "Postgres-v17 reset"
}

hardening_postgres-v17() {
    logk "i" "Hardening postgres-v17..."
    read -p "Enter Db Username: " dbUsername
    read -s -p "Enter Db Password: " password
    read -p "Enter Db Name: " dbName
    sudo -u postgres psql -c "CREATE USER $dbUsername WITH PASSWORD '$password';"
    sudo -u postgres psql -c "CREATE DATABASE $dbName;"
    sudo -u postgres psql -c "ALTER ROLE $dbUsername WITH SUPERUSER;"
    sudo -u postgres psql -c "ALTER USER postgres NOLOGIN;"
    restart_postgres-v17
    logk "i" "Hardening postgres-v17 completed"       
}

# ------ Functions ------
enable_postgres-v17() {
    logk "i" "Enabling postgres-v17..."
    sudo systemctl enable --now postgresql@17-main
    sudo systemctl status postgresql@17-main
    logk "i" "Postgres-v17 enabled"
}


restart_postgres-v17() {
    logk "i" "Restarting postgres-v17..."
    sudo systemctl restart postgresql
    sudo systemctl enable postgresql
    sudo systemctl status postgresql
    sudo pg_lsclusters 
    logk "i" "Postgres-v17 restarted"
}

configure_listen_addresses() {
    logk "i" "Enter option for listen_address"
    loge "1. localhost"
    loge "2. publicIP"
    loge "3. privateIP"
    loge "4. all"
    read -p "Enter your choice: " choice
    append_line_to_start "$K_CONFIG_PG_CONF_PATH_PG17" "$K_ADDED_BY_ADMIN"
    case $choice in
        1) append_line_to_start "$K_CONFIG_PG_CONF_PATH_PG17" "listen_addresses = 'localhost'" ;;
        2) append_line_to_start "$K_CONFIG_PG_CONF_PATH_PG17" "listen_addresses = '$(get_public_ip_v4)'" ;;
        3) append_line_to_start "$K_CONFIG_PG_CONF_PATH_PG17" "listen_addresses = '$(get_private_ip)'" ;;
        4) append_line_to_start "$K_CONFIG_PG_CONF_PATH_PG17" "listen_addresses = '*'" ;;
        *) logk "e" "Invalid choice" ;;
    esac
    logk "i" "listen_addresses configured"
}


# ------ Script ------
script_postgres() {
    logk "i" "Select the option for postgres"
    loge "1. Install postgres-v17"
    loge "2. Uninstall postgres-v17"
    loge "3. Configure postgres-v17-master"
    loge "4. Reset postgres-v17-config"
    loge "5. Hardening postgres-v17"
    loge "6. Update system"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_postgres-v17 ;;
        2) uninstall_postgres-v17 ;;
        3) configure_postgres-v17-master ;;
        4) reset_postgres-v17-config ;;
        5) hardening_postgres-v17 ;;
        5) script_system_update ;;
        *) logk "e" "Invalid choice" ;;
    esac
}


# Imp commands

# to check cluster status
# sudo pg_lsclusters 