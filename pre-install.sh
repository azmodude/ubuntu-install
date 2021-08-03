#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks1 ${DEVP}1
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksFormat --type=luks2 ${DEVP}5

echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}1 LUKS_BOOT
echo -n ${LUKS_PASSWORD} | sudo cryptsetup luksOpen ${DEVP}5 ${DM}5_crypt

sudo mkfs.ext4 -L boot /dev/mapper/LUKS_BOOT
sudo mkfs.vfat -F 16 -n EFI-SP ${DEVP}3

sudo pvcreate /dev/mapper/${DM}5_crypt
sudo vgcreate ubuntu-vg /dev/mapper/${DM}5_crypt
sudo lvcreate -L ${SWAP_SIZE} -n swap_1 ubuntu-vg
sudo lvcreate -l 100%FREE -n root ubuntu-vg

echo "Waiting for /target to appear, start installation"
while [ ! -d /target/etc/default/grub.d ]; do sleep 1; done

echo "GRUB_ENABLE_CRYPTODISK=y" | sudo tee /target/etc/default/grub.d/local.cfg
