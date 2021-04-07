#!/bin/bash

export DEV=/dev/nvme0n1
export DM="${DEV##*/}"
export DEVP="${DEV}$( if [[ "$DEV" =~ "nvme" ]]; then echo "p"; fi )"
export DM="${DM}$( if [[ "$DM" =~ "nvme" ]]; then echo "p"; fi )"

export USER="azmo"
export LVM_SIZE="100G"
export SWAP_SIZE="16G"
export LUKS_PASSWORD=test

