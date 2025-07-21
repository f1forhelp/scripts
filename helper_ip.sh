get_public_ip_v4(){
    curl -4 ifconfig.me
}

get_public_ip_v6(){
    curl -6 ifconfig.me
}

get_private_ip(){
    ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -d/ -f1 | grep -E "^(10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|192\.168\.)" | tail -1
}

get_private_ip_cidr(){
    ip addr show | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' | grep -E "^(10\.|172\.(1[6-9]|2[0-9]|3[0-1])\.|192\.168\.)" | head -1
}


log_ips(){
    logk "i" "Public IP: $(get_public_ip_v4)"
    logk "i" "Private IP: $(get_private_ip)"
    logk "i" "Private IP CIDR: $(get_private_ip_cidr)"
}