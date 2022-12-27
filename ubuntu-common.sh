#!/bin/bash

# Use a by-id link here
export DEV=/dev/disk/by-id/...
export DM="${DEV##*/}"
DEVP="${DEV}$( if [[ "$DEV" =~ "nvme" ]]; then echo "p"; fi )"
export DEVP
DM="${DM}$( if [[ "$DM" =~ "nvme" ]]; then echo "p"; fi )"
export DM

export USER="azmo"
export LVM_SIZE="100G"
export SWAP_SIZE="16G"
export LUKS_PASSWORD=test
export ENCRYPT_BOOT=0

