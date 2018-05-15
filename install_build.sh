#!/bin/bash

set -e

COLOR='\033[0;35m'
NC='\033[0m'

USER=$1

if [ -z "$1" ]
  then
    USER="ott"
fi

if [[ $(grep -c "^$USER:" /etc/passwd) = 0 ]]; then
	echo "Error: User '$USER' doesn't exist" 1>&2
	exit 1
fi

echo -e "${COLOR}----------| Installing neccessary software for the server... |----------${NC}"

sudo apt update && sudo apt install -y curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -fsSL get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh
sudo apt install -y git nodejs python-pip docker-ce nodejs
sudo pip install docker-compose

echo -e "${COLOR}----------| Inserting crontab task... |----------${NC}"

sudo crontab -l > /tmp/crontab
echo "@reboot cd /home/$USER/te-base && sudo docker-compose up | tee /home/$USER/te-base/te.log" >> /tmp/crontab
sudo crontab /tmp/crontab
rm /tmp/crontab

# Clone TE repos

cd /home/$USER/te-base

echo -e "${COLOR}----------| Cloning backend... |----------${NC}"
git clone -b dev https://github.com/WycliffeAssociates/tE-backend.git

echo -e "${COLOR}----------| Cloning frontend... |----------${NC}"
git clone -b dev https://github.com/WycliffeAssociates/translationExchange.git
cd translationExchange

# URL Fix
sed -i "s/localhost/opentranslationtools.org/g" src/config/config.js
sed -i "s/te.loc/opentranslationtools.org/g" src/config/config.js

# Build frontend
echo -e "${COLOR}----------| Building frontend... |----------${NC}"
sudo npm link cross-env
sudo npm install
sudo npm run build

echo -e "${COLOR}----------| Building docker container... |----------${NC}"
sudo docker volume create --name=postgres_data
sudo docker-compose build

# Restart machine
echo -e "${COLOR}**********| Installation complete. Rebooting... |**********${NC}"
sleep 3
sudo systemctl reboot
