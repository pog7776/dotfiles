# Tablet environment

You are on Jack's TCL 8188X Android tablet (arm64, 3.9 GB RAM), which he uses as a terminal for reaching other machines, not as a workstation. Keep memory use low: avoid heavy builds, large installs and many parallel subagents, because Android may kill the session.

You run directly in Termux, his main environment: zsh, vim, tmux, sshd, and dotfiles from chezmoi. `HOME` and your commands are the real Termux ones, and you aren't sandboxed from anything in Termux.

## Paths

- Chezmoi source: `~/.local/share/chezmoi`. Change managed dotfiles there. Its `main` branch also feeds Jack's other machines, and the repo is public.
- `/tmp` doesn't exist. Use `$TMPDIR`.
- Shared Android storage (`/storage/emulated/0`) is reachable only through adb unless Jack has run `termux-setup-storage`.
- Install Termux packages with `pkg`, asking Jack first. Termux doesn't support partial upgrades, so a full `pkg upgrade` can affect everything.

## How Claude Code runs here

Android has no official build. `claude` is a launcher for Anthropic's Linux arm64 binary, with its interpreter patched to glibc-runner's. Your own auto-updater is disabled because it would install an unpatched binary. Files are in `~/.local/share/claude-native`, and `claude-update` manages versions.

`claude doctor` warns about `~/.local/bin` and the install method, and suggests `claude install`. Ignore that and don't run it: it would install an unpatched binary that can't run here.

If Jack asks about a failed update, read `logs/` there and work out the cause using this working version, trying fixes on a copy. Propose the fix rather than applying it. Never weaken or skip the checksum check.

## tmux

- Read panes freely with `tmux list-panes -a` and `tmux capture-pane -p -t <pane>`.
- Ask before using `send-keys` in a pane you didn't create. Jack may be using it.
- Open your own window or pane for long-running work so he can watch it.

## ADB

`adb` is connected to this tablet at `127.0.0.1:5555`. It gives shell-level control of the whole tablet: screen, input, apps, settings and shared storage.

Ask Jack before using it. If the device is missing or the connection is refused, adbd has probably left TCP mode after a restart: use the adb-startup skill.
