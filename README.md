# 🛠 mesa-llvm-minimal-git Build Script
This script automates the full build process of custom Mesa and LLVM (including their 32-bit variants) from the AUR using a clean chroot environment. It's specifically tailored for users who need minimal, bleeding-edge graphics drivers — perfect for gaming setups (like Steam on Arch) or advanced development environments.

# ✅ What This Script Does
<h4>1. Prepares the environment:</h4>

- Sets up a clean workspace (<code>~/workspace</code>)

- Ensures all dependencies (like <code>devtools</code>, <code>base-devel</code>, <code>multilib-devel</code>) are installed

<h4>2. Clones AUR packages:</h4>

- <code>mesa-minimal-git</code>

- <code>llvm-minimal-git</code>

- <code>lib32-mesa-minimal-git</code>

- <code>lib32-llvm-minimal-git</code>

<h4>3. Creates a clean chroot:</h4>

- Uses <code>mkarchroot</code> and <code>arch-nspawn</code> to isolate the build environment

<h4>4. Builds packages inside the chroot in the correct order:</h4>

- <code>llvm-minimal-git</code> → <code>mesa-minimal-git</code>

- <code>lib32-llvm-minimal-git</code> → <code>lib32-mesa-minimal-git</code>

<h4>5. Installs the final packages system-wide</h4>

- <code>.pkg.tar.zst</code> files are saved to <code>~/mesa-final-packages</code>

- All packages are installed via <code>pacman -U</code>

<h4>6. Performs basic checks:</h4>

- Verifies installed packages

- Checks OpenGL and Vulkan versions

- Lists linked libraries

- Validates <code>.so</code> files and package integrity

# 🚀 How to Use
<h4>📋 Prerequisites</h4>
Make sure you are running Arch Linux with:

- <code>sudo</code> access

- A working <code>pacman</code>

- Enabled multilib repo (<code>/etc/pacman.conf</code>)

<h4>🔧 Run the Script</h4>

```bash
chmod +x build-mesa.sh
./build-mesa.sh 
```

<h4>💾 Output</h4>
Upon successful execution:

- All built packages are stored in <code>~/mesa-final-packages</code>

- Mesa and LLVM (including 32-bit variants) will be installed on your system

# ⚠️ Notes
- A reboot is recommended after installation to reload graphics drivers.

- Make sure no conflicting packages (like official <code>mesa</code> or <code>llvm</code>) are interfering before running the script.

- This script deletes <code>~/workspace</code> after completion — don’t store anything else in there during the build.

# 🙏 Credits
Built with ❤️ for Arch users who want minimal and bleeding-edge graphics stacks without headaches.
