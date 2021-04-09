#!/bin/bash

. ./ubuntu-common.sh

set -x

sudo sgdisk --zap-all ${DEV}
sudo sgdisk --new=1:0:+768M ${DEV}
sudo sgdisk --new=2:0:+2M ${DEV}
sudo sgdisk --new=3:0:+128M ${DEV}
sudo sgdisk --new=5:0:+${LVM_SIZE} ${DEV}
sudo sgdisk --new=6:0:0 ${DEV}
sudo sgdisk --typecode=1:8301 --typecode=2:ef02 --typecode=3:ef00 --typecode=5:8301 --typecode=6:bf01 ${DEV}
sudo sgdisk --change-name=1:boot --change-name=2:GRUB --change-name=3:EFI-SP --change-name=5:root --change-name=6:dpool ${DEV}
sudo sgdisk --hybrid 1:2:3 ${DEV}

sudo partprobe

echo "Rebooting is the safe option if partprobe complained."
