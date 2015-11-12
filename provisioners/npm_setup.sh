#!/usr/bin/env bash

# We need to let NPM actually work globally without dicking about with sudo
# that's ostensibly what all this stuff does
# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md

echo -e "\033[0;32m >>> Setting up NPM"

mkdir "${HOME}/.npm-packages"

echo 'NPM_PACKAGES="{HOME}/.npm-packages' >> ./.bashrc

echo 'prefix=${HOME}/.npm-packages' >> ./.npmrc

echo 'NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"' >> ./.bashrc

echo 'PATH="$NPM_PACKAGES/bin:$PATH' >> ./.bashrc

echo 'unset MANPATH' >> ./.bashrc

echo 'MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' >> ./.bashrc

source ./.bashrc
