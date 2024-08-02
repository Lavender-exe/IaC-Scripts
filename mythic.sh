###################################
#  Ubuntu 20.04 Server to 22.04   #
#  Min 8GB / 2 Cores / 200GB SSD  #
###################################

# Install Dependancies
# Add Docker's official GPG key:
#!/bin/bash
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin make

# Download Mythic
cd /home/$USER
git clone https://github.com/its-a-feature/Mythic mythic
cd mythic

# Install Mythic
sudo make
sudo ln -sr mythic-cli /bin

# Install payloads/profiles/services
# Profiles
# sudo ./mythic-cli install github https://github.com/MythicC2Profiles/httpx
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/http
sudo ./mythic-cli install github https://github.com/MythicC2Profiles/smb

# Agents
# sudo ./mythic-cli install github https://github.com/MythicAgents/Athena
sudo ./mythic-cli install github https://github.com/MythicAgents/Apollo
sudo ./mythic-cli install github https://github.com/MythicAgents/Merlin

sudo ./mythic-cli start
echo "Mythic Admin Password (CHANGE ME): $(cat .env | grep MYTHIC_ADMIN_PASSWORD)"

echo "[+] Mythic Installed Successfully!"