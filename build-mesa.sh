#!/bin/bash

export PKGDEST=~/workspace/pkg

mkdir -p ~/workspace
cd ~/workspace

set -e
cleanup() {
  log '==> Cleaning up (trap)...'
  mkdir -p ~/mesa-final-packages
  cp ~/workspace/pkg/*.pkg.tar.zst ~/mesa-final-packages || true
  [[ -d ~/workspace ]] && rm -rf ~/workspace
}
trap cleanup EXIT

log() { echo "[$(date +'%H:%M:%S')] $*"; }

# Script to Build mesa-minimal-git against llvm-minimal-git
log '==> Building mesa-minimal-git against llvm-minimal-git...'
log '==> Building dependencies...'
sudo pacman -Syy --needed devtools base-devel multilib-devel

# Check if required packages are installed
log '==> Checking for required packages...'
if ! command -v glxinfo &> /dev/null; then
  log '==> glxinfo not found. Installing mesa-utils...'
  sudo pacman -S --noconfirm mesa-utils
fi
if ! command -v vulkaninfo &> /dev/null; then
  log '==> vulkaninfo not found. Installing vulkan-tools...'
  sudo pacman -S --noconfirm vulkan-tools
fi

# Cloning Sources
log '==> Cloning git Packages...'
[[ -d mesa-minimal-git ]] || git clone https://aur.archlinux.org/mesa-minimal-git.git
[[ -d llvm-minimal-git ]] || git clone https://aur.archlinux.org/llvm-minimal-git.git
[[ -d lib32-llvm-minimal-git ]] || git clone https://aur.archlinux.org/lib32-llvm-minimal-git.git
[[ -d lib32-mesa-minimal-git ]] || git clone https://aur.archlinux.org/lib32-mesa-minimal-git.git

# Create a custom chroot for building
log '==> Creating custom chroot...'
mkarchroot ~/chroots/mesa-llvm-root base-devel multilib-devel

# Building llvm-minimal-git in clean CHROOT
log '==> Building llvm-minimal-git in clean CHROOT...'
cd llvm-minimal-git
extra-x86_64-build --chroot ~/chroots/mesa-llvm-root
# After building llvm-minimal-git -> install it to the chroot
log '==> Installing llvm-minimal-git to the chroot...'
sudo arch-nspawn ~/chroots/mesa-llvm-root pacman -U --noconfirm --ask=4 ./llvm-minimal-git-*.pkg.tar.zst

# Building mesa-minimal-git in clean CHROOT
log '==> Building mesa-minimal-git in clean CHROOT...'
cd ../mesa-minimal-git
cp ../llvm-minimal-git/*.pkg.tar.zst .
extra-x86_64-build --chroot ~/chroots/mesa-llvm-root

# Building lib32-llvm-minimal-git in clean CHROOT
log '==> Building lib32-llvm-minimal-git in clean CHROOT...'
cd ../lib32-llvm-minimal-git
extra-i686-build --chroot ~/chroots/mesa-llvm-root
log '==> Installing lib32-llvm-minimal-git to the chroot...'
sudo arch-nspawn ~/chroots/mesa-llvm-root pacman -U --noconfirm --ask=4 ./lib32-llvm-minimal-git-*.pkg.tar.zst

# Building lib32-mesa-minimal-git in clean CHROOT
log '==> Building lib32-mesa-minimal-git in clean CHROOT...'
cd ../lib32-mesa-minimal-git
cp ../lib32-llvm-minimal-git/*.pkg.tar.zst .
extra-i686-build --chroot ~/chroots/mesa-llvm-root
cd ..

# Clean up
log '==> Cleaning up...'
mkdir -p ~/mesa-final-packages
cp ~/workspace/pkg/*.pkg.tar.zst ~/mesa-final-packages
rm -rf ~/workspace

# Installing built packages
log '==> Installing built packages...'
cd ~/mesa-final-packages
sudo pacman -U --noconfirm llvm*.pkg.tar.zst
sudo pacman -U --noconfirm lib32-llvm*.pkg.tar.zst
sudo pacman -U --noconfirm mesa*.pkg.tar.zst
sudo pacman -U --noconfirm lib32-mesa*.pkg.tar.zst
cd ..

# Test if installation was successful
log '==> Testing installation...'
log '==> Verifying installed packages...'
pacman -Q mesa-minimal-git llvm-minimal-git lib32-mesa-minimal-git lib32-llvm-minimal-git
log '==> Checking OpenGL Info...'
glxinfo | grep -E 'OpenGL version|OpenGL renderer|OpenGL core'
log '==> Checking Vulkan Info...'
vulkaninfo | grep -E 'driver|apiVersion|deviceName' || log 'vulkaninfo not installed'
log '==> Checking if apps link to MESA/LLVM...'
ldd /usr/bin/glxinfo | grep -E 'libGL|llvm'
ldd /usr/bin/vulkaninfo 2>/dev/null | grep -E 'libvulkan|llvm' || log 'vulkaninfo not found'
log '==> Checking shared library versions...'
pacman -Ql mesa-minimal-git | grep '\.so'
pacman -Ql lib32-mesa-minimal-git | grep '\.so'
pacman -Ql llvm-minimal-git | grep '\.so'
pacman -Ql lib32-llvm-minimal-git | grep '\.so'
log '==> Checking for any missing shared libraries...'
pacman -Qk mesa-minimal-git llvm-minimal-git lib32-mesa-minimal-git lib32-llvm-minimal-git | grep '0 missing'
log '==> Reboot recommended to ensure driver reload.'
