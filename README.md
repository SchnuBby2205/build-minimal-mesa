# 🛠 mesa-llvm-minimal-git Build Script
This script automates the full build process of custom Mesa and LLVM (including their 32-bit variants) from the AUR using a clean chroot environment. It's specifically tailored for users who need minimal, bleeding-edge graphics drivers — perfect for gaming setups (like Steam on Arch) or advanced development environments.

# ✅ What This Script Does
<h4>1. Prepares the environment:</h4>

- Sets up a clean workspace (`~/workspace`)

- Ensures all dependencies (like `devtools`, `base-devel`, `multilib-devel`) are installed

<h4>2. Clones AUR packages:</h4>

- `mesa-minimal-git`

- `llvm-minimal-git`

- `lib32-mesa-minimal-git`

- `lib32-llvm-minimal-git`

<h4>3. Creates a clean chroot:</h4>

- Uses `mkarchroot` and `arch-nspawn` to isolate the build environment

<h4>4. Builds packages inside the chroot in the correct order:</h4>

- `llvm-minimal-git` → `mesa-minimal-git`

- `lib32-llvm-minimal-git` → `lib32-mesa-minimal-git`

<h4>5. Installs the final packages system-wide</h4>

- `.pkg.tar.zst` files are saved to `~/mesa-final-packages`

- All packages are installed via `pacman -U`

<h4>6. Performs basic checks:</h4>

- Verifies installed packages

- Checks OpenGL and Vulkan versions

- Lists linked libraries

- Validates `.so` files and package integrity

# 🚀 How to Use
<h4>📋 Prerequisites</h4>
Make sure you are running Arch Linux with:

- `sudo` access

- A working `pacman`

- Enabled multilib repo (`/etc/pacman.conf`)

<h4>🔧 Run the Script</h4>

```bash
chmod +x build-mesa.sh
./build-mesa.sh 
```

<h4>💾 Output</h4>
Upon successful execution:

- All built packages are stored in `~/mesa-final-packages`

- Mesa and LLVM (including 32-bit variants) will be installed on your system

# ⚠️ Notes
- A reboot is recommended after installation to reload graphics drivers.

- Make sure no conflicting packages (like official `mesa` or `llvm`) are interfering before running the script.

- This script deletes `~/workspace` after completion — don’t store anything else in there during the build.

# 🙏 Credits
Built with ❤️ for Arch users who want minimal and bleeding-edge graphics stacks without headaches.
