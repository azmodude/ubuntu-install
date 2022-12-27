#!/bin/bash

. ./ubuntu-common.sh

set -Eeuxo pipefail

sudo mount /dev/mapper/ubuntu--vg-root /target
for sysmount in proc sys dev etc/resolv.conf; do
  sudo mount --rbind "/${sysmount}" "/target/${sysmount}"
done
sudo cp ./post-install-chroot.sh /target/tmp
sudo LUKS_PASSWORD="${LUKS_PASSWORD}" DM="${DM}" INSTALL_DISK="${INSTALL_DISK}" chroot /target /tmp/post-install-chroot.sh
