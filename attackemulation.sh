###################################
#  Ubuntu 20.04 Server to 22.04   #
#  Min 8GB / 2 Cores / 200GB SSD  #
###################################

#!/bin/bash

# curl https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/scripts/ondemand-caldera-linux-vm-setup.sh | sudo bash

################
# Dependancies #
################

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

###############################
# Caldera Adversary Emulation #
###############################



##############################
# VECTR Purple Team Platform #
##############################

sudo systemctl enable docker
sudo docker-compose down
mkdir -p /opt/vectr
cd /opt/vectr
wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-8.2.2/sra-vectr-runtime-8.2.2-ce.zip -P /opt/vectr
unzip -o sra-vectr-runtime-8.2.2-ce.zip
docker compose down
docker compose up -d

wget https://raw.githubusercontent.com/clr2of8/dc8-deployment-PUBLIC/master/scripts/set-ip.sh -O /opt/vectr/set-ip.sh
chmod +x /opt/vectr/set-ip.sh
croncmd="sleep 30 && sudo /opt/vectr/set-ip.sh"
cronjob="@reboot $croncmd"