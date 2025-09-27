# ---- Functions ----
install_docker() {
    logk "i" "Installing docker..."
    sudo apt-get install -y docker.io
    logk "i" "Docker installed"
}

install_docker_compose() {
    logk "i" "Installing docker compose..."
    sudo apt-get install -y docker-compose
    logk "i" "Docker compose installed"
}

advertise_leader() {
    logk "i" "Advertising leader..."
    read -p "Enter the IP address to advertise: " ip_address_advertise
    docker swarm init --advertise-addr $ip_address_advertise
    logk "i" "Leader advertised"
}

promote_node_to_manager() {
    logk "i" "Promoting node to manager..."
    read -p "Enter the node ID/Hostname: " node_id
    docker node promote $node_id
    logk "i" "Node promoted to manager"
}

# ---- Options ----


script_docker() {
    logk "i" "Starting docker script..."
    logk "i" "Select the option for docker"
    loge "1. Install docker"
    loge "2. Install docker compose"
    loge "3. Advertise leader"
    loge "4. Promote node to manager"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_docker ;;
        2) install_docker_compose ;;
        3) advertise_leader ;;
        4) promote_node_to_manager ;;
        *) logk "e" "Invalid choice" ;;
    esac
}

# --- Basic Commands ---
# docker node ls