#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

for partition in $(seq 1 3); do
    sudo sgdisk --delete="${partition}" "${INSTALL_DISK}" || true
done

sudo sgdisk --new=1:0:+512M "${INSTALL_DISK}"
sudo sgdisk --new=2:0:+2G "${INSTALL_DISK}"
sudo sgdisk --new=3:0:+"${LVM_SIZE}" "${INSTALL_DISK}"

# try to re-read partitions for good measure...
sudo partprobe "${INSTALL_DISK}"
# ... still, give udev some time to create the new symlinks
sleep 2

# totally wipe old fs information
for partition in $(seq 1 3); do
  sudo wipefs -af "${INSTALL_DISK}-part${partition}"
done

sudo sgdisk --typecode=1:ef00 --typecode=2:8301 --typecode=3:8301 "${INSTALL_DISK}"
sudo sgdisk --change-name=1:EFI-SP --change-name=2:boot --change-name=3:root "${INSTALL_DISK}"

echo "Rebooting is the safe option if partprobe complained."
