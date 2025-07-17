🛠 mesa-llvm-minimal-git Build Script
This script automates the full build process of custom Mesa and LLVM (including their 32-bit variants) from the AUR using a clean chroot environment. It's specifically tailored for users who need minimal, bleeding-edge graphics drivers — perfect for gaming setups (like Steam on Arch) or advanced development environments.

✅ What This Script Does
Prepares the environment:

Sets up a clean workspace (~/workspace)

Ensures all dependencies (like devtools, base-devel, multilib-devel) are installed

Clones AUR packages:

mesa-minimal-git

llvm-minimal-git

lib32-mesa-minimal-git

lib32-llvm-minimal-git

Creates a clean chroot:

Uses mkarchroot and arch-nspawn to isolate the build environment

Builds packages inside the chroot in the correct order:

llvm-minimal-git → mesa-minimal-git

lib32-llvm-minimal-git → lib32-mesa-minimal-git

Installs the final packages system-wide

.pkg.tar.zst files are saved to ~/mesa-final-packages

All packages are installed via pacman -U

Performs basic checks:

Verifies installed packages

Checks OpenGL and Vulkan versions

Lists linked libraries

Validates .so files and package integrity

🚀 How to Use
📋 Prerequisites
Make sure you are running Arch Linux with:

sudo access

A working pacman

Enabled multilib repo (/etc/pacman.conf)

🔧 Run the Script
bash
Kopieren
Bearbeiten
chmod +x build-mesa.sh
./build-mesa.sh
💾 Output
Upon successful execution:

All built packages are stored in ~/mesa-final-packages

Mesa and LLVM (including 32-bit variants) will be installed on your system

⚠️ Notes
A reboot is recommended after installation to reload graphics drivers.

Make sure no conflicting packages (like official mesa or llvm) are interfering before running the script.

This script deletes ~/workspace after completion — don’t store anything else in there during the build.

🙏 Credits
Built with ❤️ for Arch users who want minimal and bleeding-edge graphics stacks without headaches.
