#!/data/data/com.termux/files/usr/bin/bash
# Optional: installs Ubuntu under proot-distro, for tools that need a full glibc
# userland, with Claude Code available there as `claude-proot`. It takes about
# 2 GB and is much slower than the native `claude`, so chezmoi doesn't run this.
#   bash ~/.local/share/chezmoi/termux-ubuntu-setup.sh
# To remove it: proot-distro remove ubuntu && rm "$PREFIX/bin/claude-proot"
set -e

pkg install -y proot-distro
proot-distro list 2>&1 | grep -q 'ubuntu' && proot-distro login ubuntu -- true 2>/dev/null \
  || proot-distro install ubuntu

proot-distro login --env TERMUX_UID="$(id -u)" ubuntu -- bash -c '
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq curl ca-certificates git ripgrep
curl -fsSL https://claude.ai/install.sh -o /tmp/install.sh
bash /tmp/install.sh
# tmux there would look for a root-owned socket instead of the Termux one.
cat > /usr/local/bin/tmux <<SHIM
#!/bin/sh
exec /data/data/com.termux/files/usr/bin/tmux -S /data/data/com.termux/files/usr/var/run/tmux-$TERMUX_UID/default "\$@"
SHIM
chmod 755 /usr/local/bin/tmux
' </dev/null

cat > "$PREFIX/bin/claude-proot" <<'SCRIPT'
#!/data/data/com.termux/files/usr/bin/sh
# Hide proot warnings, which otherwise print over the UI.
export PROOT_VERBOSE=-1
exec proot-distro login --work-dir "$PWD" \
  --env PATH=/root/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/data/data/com.termux/files/usr/bin \
  ubuntu -- /root/.local/bin/claude "$@"
SCRIPT
chmod 755 "$PREFIX/bin/claude-proot"
echo "Done. Start it with claude-proot; it needs its own sign-in."
