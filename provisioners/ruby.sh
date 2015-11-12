#!/usr/bin/env bash

echo -e "\033[0;32m >>> Installing Ruby \033[0m"

sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.2 ruby2.2-dev

sudo gem install jekyll
