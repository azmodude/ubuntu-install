#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

for partition in $(seq 1 5); do
    sudo sgdisk --delete="${partition}" "${DEV}" || true
done

sudo sgdisk --new=1:0:+512M "${DEV}"
sudo sgdisk --new=2:0:+2G "${DEV}"
sudo sgdisk --new=3:0:+"${LVM_SIZE}" "${DEV}"

# try to re-read partitions for good measure...
sudo partprobe "${INSTALL_DISK}"
# ... still, give udev some time to create the new symlinks
sleep 2

# totally wipe old fs information
for partition in $(seq 1 5); do
  sudo wipefs -af "${DEV}-part${partition}"
done

sudo sgdisk --typecode=1:ef00 --typecode=2:8301 --typecode=3:8301 "${DEV}"
sudo sgdisk --change-name=1:EFI-SP --change-name=2:boot --change-name=3:root "${DEV}"

echo "Rebooting is the safe option if partprobe complained."
