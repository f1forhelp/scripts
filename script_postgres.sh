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

configure_postgres-v17-single-node() {
    logk "i" "Configuring postgres-v17..."
    logk "i" "Backing up pg_hba.conf..."
    sudo cp "$configPgHbaPathPG17" "$configPgHbaPathPG17.bak"
    logk "i" "Backing up postgresql.conf..."
    sudo cp "$configPgConfPathPG17" "$configPgConfPathPG17.bak"
    logk "i" "Configuring pg_hba.conf..."
    append_line_to_end "$configPgHbaPathPG17" "host    all             all             0.0.0.0/0               md5"
    logk "i" "Configuring postgresql.conf..."
    append_line_to_start "$configPgConfPathPG17" "listen_addresses = '*'"
    logk "i" "Postgres-v17 configured"
}

reset_postgres-v17-config() {
    logk "i" "Resetting postgres-v17..."
    sudo systemctl stop postgresql@17-main
    sudo systemctl disable postgresql@17-main
    sudo rm -rf /var/lib/postgresql/17/main
    logk "i" "Postgres-v17 reset"
}

# ------ Functions ------
enable_postgres-v17() {
    logk "i" "Enabling postgres-v17..."
    sudo systemctl enable --now postgresql@17-main
    sudo systemctl status postgresql@17-main
    logk "i" "Postgres-v17 enabled"
}


# ------ Script ------
script_postgres() {
    logk "i" "Select the option for postgres"
    loge "1. Install postgres-v17"
    loge "2. Uninstall postgres-v17"
    loge "3. Configure postgres-v17-single-node"
    loge "4. Reset postgres-v17-config"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_postgres-v17 ;;
        2) uninstall_postgres-v17 ;;
        3) configure_postgres-v17-single-node ;;
        4) reset_postgres-v17-config ;;
        *) logk "e" "Invalid choice" ;;
    esac
}




