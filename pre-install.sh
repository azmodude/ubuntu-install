#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

# Ubuntu still cannot use LUKS2 for /boot
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks1 "${INSTALL_DISK}-part2"
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 "${INSTALL_DISK}-part3"

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen "${INSTALL_DISK}-part2" "${DM}-part2_crypt"
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen "${INSTALL_DISK}-part3" "${DM}-part3_crypt"

sudo mkfs.vfat -F 32 -n EFI-SP "${INSTALL_DISK}-part1"
sudo mkfs.ext4 -L boot /dev/mapper/"${DM}-part2_crypt"

sudo pvcreate /dev/mapper/"${DM}-part3_crypt"
sudo vgcreate ubuntu-vg /dev/mapper/"${DM}-part3_crypt"
sudo lvcreate -L "${SWAP_SIZE}" -n swap_1 ubuntu-vg
sudo lvcreate -l 100%FREE -n root ubuntu-vg

echo "Waiting for /target to appear, start installation"
while [ ! -d /target/etc/default/grub.d ]; do sleep 1; done

echo "GRUB_ENABLE_CRYPTODISK=y" | sudo tee /target/etc/default/grub.d/local.cfg
