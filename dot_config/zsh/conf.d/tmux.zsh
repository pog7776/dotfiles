# Oh My Zsh Tmux Plugin Configuration

# Automatically start or reconnect to a session on shell launch
# Short-circuit logic (cleanest one-liner)
[[ -t 0 && -t 1 && -z "$SSH_CONNECTION" && -z "$SSH_CLIENT" && -z "$TMUX" ]] && ZSH_TMUX_AUTOSTART=true || ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_AUTOSTART

#export ZSH_TMUX_AUTOCONNECT=true

export ZSH_TMUX_AUTOSTART_ONCE=true

export ZSH_TMUX_AUTOQUIT=false

# Modern XDG path for your tmux configuration
#export ZSH_TMUX_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"

# Ensure 256-color and terminal features pass through correctly
export ZSH_TMUX_FIXTERM=true

# Isolate SSH sessions from your local Windows Terminal session
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
  # SSH: Create a NEW isolated session on connect
  export ZSH_TMUX_AUTOCONNECT=false
  export ZSH_TMUX_AUTONAME_SESSION=false
else
  # Local: Automatically reconnect to active session
  export ZSH_TMUX_AUTOCONNECT=true
  export ZSH_TMUX_AUTONAME_SESSION=true
fi

# tsh HOST [SESSION]: attach to (or create) a persistent tmux session on a server.
# The session survives disconnects, and Claude can read it with capture-pane.
# From inside local tmux, press F12 first so keys go to the server's tmux.
tsh() { ssh -t "$1" "tmux new -A -s ${2:-main}"; }

# Load the plugin
plugins+=(tmux)
