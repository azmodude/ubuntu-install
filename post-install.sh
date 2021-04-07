#!/bin/bash

set -vx

. ./ubuntu-common.sh

sudo mount /dev/mapper/ubuntu--vg-root /target
for n in proc sys dev etc/resolv.conf; do
	sudo mount --rbind /$n /target/$n
done
sudo cp ./post-install-chroot.sh /target/tmp
sudo LUKS_PASSWORD=${LUKS_PASSWORD} DM=${DM} DEVP=${DEVP} chroot /target /tmp/post-install-chroot.sh
