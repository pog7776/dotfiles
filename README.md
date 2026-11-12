# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io).

## Quick start (fresh machine)

```
sh -c "$(curl -fsLS https://raw.githubusercontent.com/pog7776/dotfiles/main/bootstrap.sh)"
```

This installs `curl`/`git` if missing, installs [chezmoi](https://chezmoi.io) into
`~/.local/bin`, then clones and applies this repo. Applying runs a chain of
`run_once_`/`run_onchange_` scripts that install packages, oh-my-zsh, oh-my-tmux, zsh
plugins/theme, and correct the account's login shell.

If you already have chezmoi installed, you can skip straight to:
```
chezmoi init --apply pog7776/dotfiles
```

## Machine roles

The first `chezmoi init` on a machine asks for its **role**, which is stored in
that machine's `~/.config/chezmoi/chezmoi.toml` (`.chezmoi.toml.tmpl`):

| Role | For | Differences |
|---|---|---|
| `workstation` | personal machines (default) | everything |
| `server` | headless boxes (sulaco, z10) | no fonts, opencode, tmuxai or p4; jack-agent key added to `authorized_keys` |
| `thin` | thin clients | no opencode, tmuxai or p4 |
| `termux` | Android | chosen automatically |

Skip the prompt with `ROLE=server` for `bootstrap.sh`, or with
`chezmoi init --promptChoice "Machine role=server" ...`. To change a machine's
role, run `chezmoi init --promptChoice "Machine role=<role>"` again.

Per-host settings live in `.chezmoidata/hosts.yaml`: the tmux accent colour (so you can
tell which host's tmux you're in) and extra SSH keys by role.

## tmux over SSH

- `tsh HOST [SESSION]` attaches to (or creates) a persistent session on a server.
- **F12** turns the local tmux "off", so keys go to the server's tmux inside it.
  The status bar shows `[OFF → inner tmux]`; press F12 again to return.

## What's managed here

- **Shell**: `.zshrc`, `.config/zsh/` (`config.zsh` + `conf.d/*.zsh` modules), `.bashrc`, `.profile`
- **tmux**: `.config/tmux/tmux.conf.local` (template: per-host accent, F12 toggle)
- **SSH**: `.ssh/authorized_keys` (merged rather than replaced: GitHub keys of pog7776 and Trickle-Charge-bot, plus role-based extras)
- **btop**: `.config/btop/btop.conf`
- **tmuxai**: `.config/tmuxai/config.yaml`, skills
- **opencode**: `.config/opencode/opencode.jsonc`, `package.json`

## Bootstrap scripts (`run_once_`/`run_onchange_`)

| Script | Purpose |
|---|---|
| `run_onchange_before_install-packages.sh.tmpl` | Installs OS packages via the native package manager. Runs first (`before_`). |
| `run_once_change-shell.sh.tmpl` | `chsh`s to zsh if the account's login shell isn't already zsh. |
| `run_once_install-oh-my-zsh.sh.tmpl` | Installs oh-my-zsh (unattended, keeps the chezmoi-managed `.zshrc`). |
| `run_once_install-oh-my-tmux.sh.tmpl` | Clones [gpakosz/.tmux](https://github.com/gpakosz/.tmux) and symlinks `~/.config/tmux/tmux.conf` to it. |
| `run_once_install-zsh-plugins.sh.tmpl` | Clones `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`. |
| `run_once_install-zsh-themes.sh.tmpl` | Clones the `powerlevel10k` theme. |
| `run_once_install-docker.sh.tmpl` | Installs Docker Engine (`docker-ce`) from Docker's official repo (ubuntu/debian/arch/fedora) if not already present. Skipped entirely if `docker` is already on `PATH`. Deliberately does *not* add the account to the `docker` group (root-equivalent access) — use `sudo docker ...`. |

## Cross-distro package installation

Package lists and install commands live in `.chezmoidata/packages.yaml`, keyed by
distro (`ubuntu`, `debian`, `arch`, `fedora`, plus `android` for Termux). The install script is a generic lookup
based on `.chezmoi.osRelease.id` (`.chezmoi.os` on Termux, which has no os-release) — adding a new distro means editing the YAML data,
not the script. Unsupported distros fail with a clear error rather than a confusing
`apt-get: command not found`.

## Useful commands

```
chezmoi diff              # preview changes before applying
chezmoi apply -v          # apply changes
chezmoi cd                # cd into the source dir (plain git repo)
chezmoi edit ~/.zshrc     # edit the source copy of a managed file
chezmoi execute-template < some_file.tmpl   # test a template's rendered output
```

## Termux

`bootstrap.sh` doesn't support Termux; install directly:

```sh
pkg install -y chezmoi git
chezmoi init --apply pog7776/dotfiles
```

Docker is skipped, `.ssh/authorized_keys` isn't managed, and the font goes to
`~/.termux/font.ttf`. Run scripts use a templated shebang because Android has no
`/bin/bash`; it must keep rendering as `/bin/bash` elsewhere, since changing a
script's rendered contents re-runs it on every machine.
