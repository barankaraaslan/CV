mkdir build -m 777
cd build
sudo -u nobody git clone https://aur.archlinux.org/texlive-moderncv-git.git
cd texlive-moderncv-git
source PKGBUILD
pacman -Syu --noconfirm ${makedepends[@]} ${depends[@]}
sudo -u nobody makepkg
pacman -U --noconfirm *.zst