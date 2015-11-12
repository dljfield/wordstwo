#!/usr/bin/env bash

echo -e "\033[0;32m >>>>>>>> STARTING PROVISIONING (I'd say to hold onto your hat, but you look terrible in it) \033[0m"

echo -e "\033[0;32m >>> Setting Timezone & Locale \033[0m"

sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sudo locale-gen C.UTF-8
export LANG=C.UTF-8

echo "export LANG=C.UTF-8" >> /home/vagrant/.bashrc

sudo apt-get update

sudo apt-get install -qq curl unzip ack-grep software-properties-common build-essential
