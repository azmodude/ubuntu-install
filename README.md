Based on https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019

## Usage

1. Boot into your .iso - choose 'Try'
2. Clone repository
3. Adjust variables in ubuntu-common.sh
4. ./pre-install-partition.sh && ./pre-install.sh
5. Start Installation as normal
    - You will end up with an encrypted LUKS1 /boot
    - Encrypted LUKS2 / and swap-space
    - An empty partition to be used for ZFS
6. After install select 'Continue Testing'
7. ./post-install.sh
    - This sets up your LUKS installation so you only have to enter your password once
      by generating a random keyfile saved in `/etc/luks/boot_os.keyfile` and adding
      to the LVM LUKS partition
8. Reboot
9. Change to a console and login as root
10. Clone repository again
11. Adjust variable for $DEV in ubuntu-common.sh
12. Execute ./first-boot.sh
13. Log back in as user
    - Your /home is now on a ZFS dataset


Hibernate works!

update-initramfs: Generating /boot/initrd.img-5.8.0-38-generic
I: The initramfs will attempt to resume from /dev/dm-1
I: (/dev/mapper/ubuntu--vg-swap_1)
I: Set the RESUME variable to override this.

