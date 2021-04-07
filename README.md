# Ubuntu install with encrypted ZFS /home and encrypted /boot and / LUKS

Based on https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019

## Usage

1. Boot into your .iso - choose 'Try'
2. Clone repository
3. Adjust variables in ubuntu-common.sh
4. ./pre-install-partition.sh && ./pre-install.sh
   - The pre-install.sh script will keep waiting for the install target to appear
5. Start Installation as usual
    - Choose Manual partitioning
      - /dev/mapper/LUKS_BOOT --> ext4, MountPoint /boot
      - /dev/mapper/ubuntu--vg-root --> w/e you like, MountPoint /
      - /dev/mapper/ubuntu--vg-swap_1 --> swap area
    - As soon as /target appears the previous script will exit normally
    - You will end up with an encrypted LUKS1 /boot
    - Encrypted LUKS2 / and swap-space
    - An empty partition to be used for ZFS
6. After install select 'Continue Testing'
7. ./post-install.sh
    - This sets up your LUKS installation so you only have to enter your password once
      by generating a random keyfile saved in `/etc/luks/boot_os.keyfile` and adding
      to the LVM LUKS partition
8. Reboot
9. change to a console and login as user
    a) enable root account by setting a password `sudo passwd`
    b) logout, login as root
10. Clone repository again
11. Adjust variable for $DEV in ubuntu-common.sh
12. Execute ./first-boot.sh
13. Log back in as user
    - Your /home is now on a ZFS dataset

## Misc

- Tested on Ubuntu 20.10 and Kubuntu 20.10
- Hibernate works just fine (technically, it does for me)
