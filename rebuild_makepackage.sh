#!/bin/bash

if [[ $# -eq 0 ]] ; then
    VERSION=$(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    echo "No argument supplied! "
    echo 'Try:'
    echo "  $0 $VERSION"
    exit 1
fi

source ~/.ghcup/env

export GHC_VERSION=8.10.4


BEGIN=$(date)
cd cardano-node
git pull
git checkout $1

echo "package cardano-crypto-praos" >> cabal.project.local
echo "  flags: -external-libsodium-vrf" >> cabal.project.local

echo "package trace-dispatcher" >> cabal.project.local
echo "  ghc-options: -Wwarn" >> cabal.project.local
echo "" >> cabal.project.local


datetime && cabal configure --with-compiler=ghc-$GHC_VERSION
cabal build all
END=$(date)

cp -p $(find ./dist-newstyle/build/ -type f -name "cardano-node") ~/.local/bin/
cp -p $(find ./dist-newstyle/build/ -type f -name "cardano-cli") ~/.local/bin/

cardano-node --version
cardano-cli  --version

echo "BEGIN: $BEGIN  --- END: $END"
