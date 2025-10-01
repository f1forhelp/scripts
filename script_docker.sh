# ---- Functions ----
install_docker() {
    logk "i" "Installing docker..."
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    sudo apt-get install lsb-release

    # Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo systemctl status docker

    logk "i" "Docker installed"
}

advertise_leader() {
    logk "i" "Advertising leader..."
    read -p "Enter the private IP address to advertise: " private_ip
    docker swarm init --advertise-addr $private_ip
    logk "i" "Leader advertised"
}

promote_node_to_manager() {
    logk "i" "Promoting node to manager run this command on leader node"
    read -p "Enter the hostname to promote: " hostname
    docker node promote $hostname
    logk "i" "Node promoted to manager"
}

docker_login_ghcr() {
    logk "i" "Logging in to ghcr..."
    read -p "Enter the username: " username
    read -s -p "Enter the password: " password; echo
    docker login ghcr.io -u $username -p-stdin $password
    logk "i" "Logged in to ghcr"
}

docker_logout_ghcr() {
    logk "i" "Logging out from ghcr..."
    docker logout ghcr.io
    logk "i" "Logged out from ghcr"
}

# ---- Options ----


script_docker() {
    logk "i" "Starting docker script..."
    logk "i" "Select the option for docker"
    loge "1. Install docker"
    loge "2. Advertise leader"
    loge "3. Promote node to manager"
    loge "4. Login to ghcr"
    loge "5. Logout from ghcr"
    read -p "Enter your choice: " choice
    case $choice in
        1) install_docker ;;
        2) advertise_leader ;;
        3) promote_node_to_manager ;;
        4) docker_login_ghcr ;;
        5) docker_logout_ghcr ;;
        *) logk "e" "Invalid choice" ;;
    esac
}

# --- Basic Commands ---
# docker node ls

# https://www.youtube.com/watch?v=nmas_zbcMeU&t=88s
# https://www.youtube.com/watch?v=RgZyX-e6W9E
# https://www.youtube.com/watch?v=_YsPt7dIvqU
