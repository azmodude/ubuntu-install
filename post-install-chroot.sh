#!/bin/bash

set -Eeuxo pipefail

sudo mount -a

sudo apt-get install -y cryptsetup-initramfs

echo "KEYFILE_PATTERN=/etc/luks/*.keyfile" | sudo tee -a /etc/cryptsetup-initramfs/conf-hook
echo "UMASK=0077" | sudo tee -a /etc/initramfs-tools/initramfs.conf

sudo mkdir /etc/luks
sudo openssl rand -hex -out "/etc/luks/boot_os.keyfile" 32
sudo chmod 700 /etc/luks
sudo chmod 600 /etc/luks/boot_os.keyfile

echo -n "${LUKS_PASSWORD}" | sudo cryptsetup luksAddKey "${DEVP}1" /etc/luks/boot_os.keyfile
echo -n "${LUKS_PASSWORD}" | sudo cryptsetup luksAddKey "${DEVP}5" /etc/luks/boot_os.keyfile

echo "LUKS_BOOT UUID=$(blkid -s UUID -o value "${DEVP}1") /etc/luks/boot_os.keyfile luks,discard" | sudo tee -a /etc/crypttab
echo "${DM}5_crypt UUID=$(blkid -s UUID -o value "${DEVP}5") /etc/luks/boot_os.keyfile luks,discard" | sudo tee -a /etc/crypttab

sudo update-initramfs -u -k all
