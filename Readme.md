# For server hardening
curl -fsSL "https://raw.githubusercontent.com/f1forhelp/scripts/refs/heads/main/init.sh" -o init.sh && chmod +x init.sh && ./init.sh

netbird up --allow-server-ssh



# Netbird install after ufw
sudo apt update
sudo apt-get install -y ufw
sudo ufw enable
sudo systemctl enable --now ufw
sudo systemctl status ufw
curl -fsSL https://pkgs.netbird.io/install.sh | sh
netbird up --allow-server-ssh


# Netbird install before ufw
sudo apt update
curl -fsSL https://pkgs.netbird.io/install.sh | sh
netbird up --allow-server-ssh
sudo apt-get install -y ufw
sudo ufw enable
sudo systemctl enable --now ufw
sudo systemctl status ufw
