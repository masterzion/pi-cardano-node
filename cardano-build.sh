#!/bin/bash
#
# Before running this script
# https://cardano-node-installation.stakepool247.eu/cardano-node-installation-and-configuration-guide/creating-a-user
# https://cardano-node-installation.stakepool247.eu/adding-swap-virtual-memory
#
# ref: https://cardano-node-installation.stakepool247.eu/cardano-node-prerequisites
# Tested on Raspberry 4 8GB
# MicroSD: 32GB
# IMPORTANT: Only compatible with Ubuntu arm64 (it wont work with raspian "Error: selected processor does not support `movw r3,:lower16:c4qi_info$def' in ARM mode")
# ubuntu-20.04.3-preinstalled-server-arm64+raspi.img.xz
#
# uname -a
# Linux raspberrypi 5.10.63-v7l+ #1459 SMP Wed Oct 6 16:41:57 BST 2021 armv7l GNU/Linux


export GHC_VERSION=8.10.4
export CABAL_VERSION=3.4.0.0


mkdir -p ~/.local/bin/

git clone https://github.com/input-output-hk/libsodium
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install
cd ..

echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo "export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH" >> ~/.bashrc
echo PATH="$PATH:$HOME/.local/bin/" >> $HOME/.bashrc
source ~/.bashrc

export BOOTSTRAP_HASKELL_NONINTERACTIVE=1


curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

source ~/.ghcup/env


ghcup install cabal $CABAL_VERSION
ghcup set cabal $CABAL_VERSION

ghcup install ghc $GHC_VERSION
ghcup set ghc $GHC_VERSION

cabal --version
ghc --version

git clone https://github.com/input-output-hk/cardano-node.git

cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout $(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

cabal configure --with-compiler=ghc-$GHC_VERSION

echo "package cardano-crypto-praos" >> cabal.project.local
echo "  flags: -external-libsodium-vrf" >> cabal.project.local

echo "package trace-dispatcher" >> cabal.project.local
echo "  ghc-options: -Wwarn" >> cabal.project.local
echo "" >> cabal.project.local

cabal build all

cp -p $(find ./dist-newstyle/build/ -type f -name "cardano-node") ~/.local/bin/
cp -p $(find ./dist-newstyle/build/ -type f -name "cardano-cli") ~/.local/bin/

source ~/.bashrc
