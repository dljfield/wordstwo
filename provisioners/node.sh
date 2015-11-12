#!/usr/bin/env bash

echo -e "\033[0;32m >>> Installing nodejs \033[0m"

curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs
