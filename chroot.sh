#!/bin/bash
set -x
set -e

cd ~
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
read -p "Enter device's name: " device_name
echo "${device_name}" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 ${device_name}.localdomain ${device_name}" >> /etc/hosts

passwd
read -p "Enter new user's name: " user_name
useradd -m ${user_name}
usermod -aG wheel,audio,video ${user_name}
passwd ${user_name}

pacman -S \
	grub grub-btrfs efibootmgr os-prober \
	intel-ucode base-devel linux-headers \
	smartmontools mtools dosfstools cryptsetup btrfs-progs ntfs-3g \
	xdg-user-dirs xdg-utils \
	git openssh rsync stow syncthing wget \
	htop wget firewalld cronie nmap \
	networkmanager network-manager-applet wpa_supplicant \
	bluez bluez-utils blueman\
	alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack easyeffects \
	acpi acpid xf86-input-libinput chrony tlp xf86-input-wacom \
	feh dunst flameshot lxappearance neofetch \
	vim emacs tmux \
	bash-completion dialog \
	i3-gaps xorg xorg-xinit xorg-xrandr xorg-xbacklight xorg-xsetroot xfce4-power-manager wmctrl \
	android-tools \
	atool p7zip unrar unzip ark \
	discord firefox qbittorrent inkscape krita blender virtualbox okular \
	ffmpeg imagemagick obs-studio vlc \
	python python-pip \
	ttf-ubuntu-font-family 
	
#    nvidia nvidia-utils nvidia-settings nvidia-prime \
#	 mesa xf86-video-intel \

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable \
	NetworkManager \
	bluetooth \
	sshd \
	tlp \
	firewalld \
	acpid

EDITOR=vim visudo

printf "\n In the start 'MODULES=()' to 'MODULES=(btrfs nvidia)' \n In below down 'HOOKS=(...block filesystem...)' to 'HOOKS=(...block encrypt filesystem...)'\n"
while true; do
    read -p "Press Y/y to edit mkinitcpio.conf " yn
    case $yn in
        [Yy]* ) vim /etc/mkinitcpio.conf ; break;;
        [Nn]* ) exit;;
    esac
done
mkinitcpio -p linux

read -p "Enter root partition (eg. sda2) " root_partition
root_UUID=$(blkid -s UUID -o value /dev/${root_partition})
printf '\n In the start "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"" to "GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot"" \n for virtual machine only "GRUB_LINUX_CMDLINE_DEFAULT="loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot video=1920x1080"" \n \n \n Go to last line of the file to copy above syntax \n'

echo "#loglevel=3 quiet cryptdevice=UUID=${root_UUID}:cryptroot root=/dev/mapper/cryptroot" >> /etc/default/grub
while true; do
    read -p "Press Y/y to edit grub " yn
    case $yn in
        [Yy]* ) vim /etc/default/grub ; break;;
        [Nn]* ) exit;;
    esac
done
grub-mkconfig -o /boot/grub/grub.cfg

echo "Script finished successfully."
