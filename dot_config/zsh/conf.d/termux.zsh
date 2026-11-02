# Termux startup. Ignored on other systems by .chezmoiignore.
[[ -n $TERMUX_VERSION ]] || return 0

# Start sshd. If it's already running, this one can't bind the port and exits.
sshd 2>/dev/null

# Reconnect adb to this device in the background. This only works while adbd
# is in TCP mode, which Android resets on restart: run adb-tcp-up to turn it
# back on.
(adb connect 127.0.0.1:5555 >/dev/null 2>&1 &)
