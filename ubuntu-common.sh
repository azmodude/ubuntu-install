#!/bin/bash

# Use a by-id link here
export INSTALL_DISK=/dev/disk/by-id/...
export DM="${INSTALL_DISK##*/}"

export USER="azmo"
export LVM_SIZE="100G"
export SWAP_SIZE="16G"
export LUKS_PASSWORD=test
export ENCRYPT_BOOT=0

