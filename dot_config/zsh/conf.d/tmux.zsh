# Oh My Zsh Tmux Plugin Configuration

# Automatically start or reconnect to a session on shell launch
export ZSH_TMUX_AUTOSTART=true
# export ZSH_TMUX_AUTOCONNECT=true
export ZSH_TMUX_AUTOSTART_ONCE=true

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

# Load the plugin
plugins+=(tmux)
