#!/bin/bash

swapon -s
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo 'vm.swappiness=10' >> /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' >> /etc/sysctl.conf

apt-get update -y
apt-get upgrade -y

apt-get install curl libnuma-dev llvm-9 wget python3 build-essential screen pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev systemd libsystemd-dev libsodium-dev zlib1g-dev yarn make g++ jq libncursesw5 libtool autoconf automake git tmux htop nload -y

libnuma-dev

echo "adding cuser for CARDANO"
adduser cardano
usermod -aG sudo cardano

cp cardano-build.sh ../../cardano/
chown cardano:cardano ../../cardano/cardano-build.sh
su - cardano
