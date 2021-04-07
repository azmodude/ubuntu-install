#!/bin/bash
set -Eeuxo pipefail
trap read DEBUG

if [ "$(id -u)" != 0 ]; then
    echo "Please execute with root rights."
    exit 1
fi

. ./ubuntu-common.sh

DISK_ID=""
for link in $(udevadm info --query=symlink --name=${DEV}); do
    echo "${link}" | grep -q "by-id" && DISK_ID="$link"
done

[[ -z ${DISK_ID} ]] && echo "Could not get /dev/disk/by-id for ${DEV}" && exit 99

# Install ZFS
apt-get -y install zfsutils-linux

# Create zfs key
openssl rand -hex -out "/etc/zfs/zfskey_dpool_$(hostname)" 32
chown root:root "/etc/zfs/zfskey_dpool_$(hostname --fqdn)" &&
    chmod 600 "/etc/zfs/zfskey_dpool_$(hostname --fqdn)"

# Setup ZFS pool
# TODO: Encrypt the whole pool? Probably the best idea for a laptop,
# still we lose some flexibility here. Another way of doing it is creating
# the dpool/home dataset encrypted and let hierarchy inherit it.
# This bears the danger of having stuff like e.g. lxd and docker containers
# leaking data
zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O encryption=aes-256-gcm \
    -O keylocation="file:///etc/zfs/zfskey_dpool_$(hostname)" \
    -O keyformat=raw -O acltype=posixacl -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on \
    -O xattr=sa -O canmount=off -O mountpoint=/ dpool \
    -R /tmp/dpool /dev/disk/by-id/$(basename ${DISK_ID})-part6
zpool set cachefile=/etc/zfs/zpool.cache dpool

# setup generic ZFS datasets and move old home over
zfs create -p -o mountpoint=/home/${USER} dpool/home/${USER}
chown -R ${USER}:${USER} /tmp/dpool/home/${USER}
# the slashes here DO matter
rsync -vau /home/${USER}/ /tmp/dpool/home/${USER}/
rm -rf /home
zpool export dpool
zpool import dpool
zfs load-key -L file:///etc/zfs/zfskey_dpool_$(hostname) dpool
zfs mount -a

# Create and enable zfs-load-key.service
cp ./zfs-load-key@.service /etc/systemd/system
systemctl daemon-reload
systemctl enable zfs-load-key@dpool.service
