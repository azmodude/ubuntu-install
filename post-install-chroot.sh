#!/bin/bash

set -Eeuxo pipefail

sudo mount -a

sudo apt-get install -y cryptsetup-initramfs

echo "KEYFILE_PATTERN=/etc/luks/*.keyfile" | sudo tee -a /etc/cryptsetup-initramfs/conf-hook
echo "UMASK=0077" | sudo tee -a /etc/initramfs-tools/initramfs.conf

sudo mkdir -p /etc/luks
sudo openssl rand -hex -out "/etc/luks/boot_os.keyfile" 32
sudo chmod 700 /etc/luks
sudo chmod 600 /etc/luks/boot_os.keyfile

echo -n "${LUKS_PASSWORD}" | sudo cryptsetup luksAddKey "${INSTALL_DISK}-part2" /etc/luks/boot_os.keyfile
echo -n "${LUKS_PASSWORD}" | sudo cryptsetup luksAddKey "${INSTALL_DISK}-part3" /etc/luks/boot_os.keyfile

echo "boot_crypt UUID=$(blkid -s UUID -o value "${INSTALL_DISK}-part2") /etc/luks/boot_os.keyfile luks,discard" | sudo tee -a /etc/crypttab
echo "ubuntu--vg-root UUID=$(blkid -s UUID -o value "${INSTALL_DISK}-part3") /etc/luks/boot_os.keyfile luks,discard" | sudo tee -a /etc/crypttab

sudo update-initramfs -u -k all
