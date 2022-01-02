![pi-cardano-node logo](https://github.com/masterzion/pi-cardano-node/blob/main/imgs/logo.png?raw=true)

# pi-cardano-node

This script will help you to build and create the cardano binary files which run on a raspberry pi 4.

Even though i am leaving the binaries files here:

https://github.com/masterzion/pi-cardano-node/tree/main/builded-files

I always recommend to build your own version to avoid some risk.
Feel free to check and improve the scripts. It's all open source.

# Required:
 - Raspberry 4 8GB (It requires 8GB to build)

![Build memory usage](https://github.com/masterzion/pi-cardano-node/blob/main/imgs/memory.png?raw=true)

 - Ubuntu arm64 (ubuntu-20.04.3-preinstalled-server-arm64+raspi.img)

https://ubuntu.com/download/raspberry-pi/thank-you?version=20.04.3&architecture=server-arm64+raspi

 - External SSD card (for cardano db)
 - MicroSD (32GB recommended to have some swap)



Version:
 ```bash
 uname -a
 Linux ubuntu 5.4.0-1042-raspi #46-Ubuntu SMP PREEMPT Fri Jul 30 00:35:40 UTC 2021 aarch64 aarch64 aarch64 GNU/Linux
 ```

IMPORTANT:

Only compatible with linux arm64! It wont work with raspian armv7. You will have this error if you try to build:
```
"Error: selected processor does not support `movw r3,:lower16:c4qi_info$def' in ARM mode")
```

# How to

1) Write the image and connect your SSD

https://www.raspberrypi.com/documentation/computers/getting-started.html


2) connect to your raspberry pi (the default pwd is ubuntu)
```bash
ssh ubuntu@UBUNTU_IP_ADDR
```

3) Clone this repo

```bash
git clone https://github.com/masterzion/pi-cardano-node.git
```

3) Prepare the linux, install dependences, create a cardano user
(requires sudo). At the end set the password for the user cardano
```bash
cd pi-cardano-node
ls
sudo ./cardano-prepare-linux.sh
```

4) The previous script will already leave you logged in with the cardano user... run the build script (already in cardano home dir)

```bash
./cardano-build.sh
```

5) Go sleep... it will take many many hours... (10 hours?)

6) At the binary files will be present on ~/.local/bin/

Files:
```bash
cardano@ubuntu:~/cardano-node$ ls -lah ~/.local/bin/
total 403M
drwxrwxr-x 2 cardano cardano 4.0K Jan  2 21:14 .
drwxrwxr-x 4 cardano cardano 4.0K Jan  2 03:58 ..
-rwxrwxr-x 1 cardano cardano 188M Jan  2 20:21 cardano-cli
-rwxrwxr-x 1 cardano cardano 215M Jan  2 20:33 cardano-node
cardano@ubuntu:~/cardano-node$
```

7) Enjoy. :)

8) If you want to build again or do some changes, login with the cardano user and set the build environment

```bash
source ~/.ghcup/env
```

Based on the link bellow.
Additional fixes and dependencies were added to make it work with the latest version.

https://cardano-node-installation.stakepool247.eu/cardano-node-prerequisites
