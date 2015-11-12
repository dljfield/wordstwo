#!/usr/bin/env bash

echo -e "\033[0;32m >>> Installing nginx \033[0m"

sudo add-apt-repository -y ppa:nginx/stable
sudo apt-get update
sudo apt-get install -qq nginx

usermod -a -G www-data vagrant

sed -i "s/user www-data;/user vagrant;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sudo service nginx restart
