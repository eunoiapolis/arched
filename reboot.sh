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
	brave-bin spotify cloudflare-warp-bin figma-linux notion-app-enhanced obsidian-appimage \
	nerd-fonts-jetbrains-mono arc-icon-theme-full-git gtk-theme-arc-gruvbox-git noto-fonts-emoji \
	picom-ibhagwan-git \
	ipscan
# woeusb-gui

paru -S zramd
sudo vim /etc/default/zramd
sudo systemctl enable --now zramd.service

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo pacman -Syy
