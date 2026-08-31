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

## What's managed here

- **Shell**: `.zshrc`, `.config/zsh/` (`config.zsh` + `conf.d/*.zsh` modules), `.bashrc`, `.profile`
- **tmux**: `.config/tmux/tmux.conf.local`
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
| `run_once_install-zsh-plugins.sh` | Clones `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf-tab`. |
| `run_once_install-zsh-themes.sh` | Clones the `powerlevel10k` theme. |

## Cross-distro package installation

Package lists and install commands live in `.chezmoidata/packages.yaml`, keyed by
distro (`ubuntu`, `debian`, `arch`, `fedora`). The install script is a generic lookup
based on `.chezmoi.osRelease.id` — adding a new distro means editing the YAML data,
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
