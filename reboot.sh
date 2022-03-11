set -x
set -e

cd ~
git clone https://github.com/eunoiapolis/.latent.git
cd .latent
stow --adopt -v -t ~ */
stow -D -v -t ~ */
cd ~
rm -rf .latent/
git clone https://github.com/eunoiapolis/.latent.git
cd .latent
stow --adopt -v -t ~ */
cd ~

sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin/
makepkg -si
cd ..
rm -rf ./paru-bin

paru -S timeshift-bin
paru -S \
	timeshift-autosnap \
	brave-bin \
	nerd-fonts-jetbrains-mono \
	picom-ibhagwan-git \
	ipscan

paru -S zramd
doas vim /etc/default/zramd
doas systemctl enable --now zramd.service

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
sudo reflector --latest 30 --sort rate --save /etc/pacman.d/mirrorlist

sudo pacman -Syy