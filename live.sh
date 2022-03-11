#!/bin/bash
set -x
set -e

timedatectl set-ntp true

lsblk | less
echo "Create three partitions, first for boot, second for root, third for data"
read -p "Enter disk to partition: " disk_to_install
gdisk /dev/${disk_to_install}
boot_partition=${disk_to_install}1
root_partition=${disk_to_install}2
data_partition=${disk_to_install}3

cryptsetup luksFormat /dev/${root_partition}
cryptsetup luksFormat /dev/${data_partition}
cryptsetup luksOpen /dev/${root_partition} cryptroot
cryptsetup luksOpen /dev/${data_partition} cryptdata

mkfs.btrfs /dev/mapper/cryptroot
mkfs.ext4 /dev/mapper/cryptdata
mkfs.vfat /dev/${boot_partition}

mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var
umount /mnt

mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@ /dev/mapper/cryptroot /mnt
mkdir /mnt/{boot,home,var}
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd,space_cache=v2,discard=async,subvol=@var /dev/mapper/cryptroot /mnt/var
mount /dev/${boot_partition} /mnt/boot

pacstrap /mnt base linux linux-firmware intel-ucode btrfs-progs git wget unzip vim

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt