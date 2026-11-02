#!/data/data/com.termux/files/usr/bin/bash
# Optional: installs Ubuntu under proot-distro, for tools that need a full glibc
# userland. It takes about 2 GB and runs slowly, so chezmoi doesn't run this.
#   bash ~/.local/share/chezmoi/termux-ubuntu-setup.sh
# Then enter it with: proot-distro login ubuntu
# PROOT_VERBOSE=-1 hides proot warnings, which can print over full-screen programs.
# To remove it: proot-distro remove ubuntu
set -e

pkg install -y proot-distro
proot-distro login ubuntu -- true 2>/dev/null || proot-distro install ubuntu

proot-distro login ubuntu -- bash -c '
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq curl ca-certificates git
' </dev/null

echo "Done. Enter it with: proot-distro login ubuntu"
