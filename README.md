# dot-🐟-y (my dotfiles)
Since new Macbooks are so fragile, I've created repo to setup my Mac faster.
It installs [Fish](https://fishshell.com/) as a shell and [Solarized Light](https://ethanschoonover.com/solarized/) theme across apps.
The killer feature is the [Hyper key](http://brettterpstra.com/2012/12/08/a-useful-caps-lock-key/) config with lots of shortcuts.

![iTerm](https://i.imgur.com/StrxYCA.png)

## How it works
Everything is declared in [`mise/`](mise/) and applied with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html):
packages, dotfile symlinks, macOS defaults, login shell and dev tools. `~/.config/mise` is a symlink to `~/.dotfishy/mise`.

Each machine loads `mise/config.toml` plus two layers, an OS and a role:

| Machine | Set up by | `-E` | Gets |
|---|---|---|---|
| Private MacBook | `install.sh` | `macos,priv` | everything Mac + private apps |
| Work MacBook | `install.sh` | `macos,work` | everything Mac + work apps |
| Mac mini (build server) | `install.sh` | `macos,mini` | everything Mac + colima/docker |
| ant-dev | [ant-hill](https://github.com/jakubdyszkiewicz/ant-hill) | `linux,dev` | shell/vim/tmux + Go |
| ant-services, ant-hill | [ant-hill](https://github.com/jakubdyszkiewicz/ant-hill) | `linux` | shell/vim/tmux |

On Macs the role comes from the gitignored `profile` file (also read by fish and Hammerspoon).
On Linux, Ansible installs mise, clones this repo and runs `mise bootstrap --only dotfiles,tools`;
apt packages, users, docker etc. stay in Ansible.

## A fresh MacOS Setup

### Before reinstall
Before wiping your Mac, check those:
* Commit and push any changes/branches to your git repositories (including ~/.dotfishy).
* Save all important documents from non-synced directories.
* Save all of your work from apps which aren't synced through iCloud.

### Setting up
1. Update macOS to the latest version with the App Store
2. Install macOS Command Line Tools by running `xcode-select --install` (required for git)
3. Sign in to Mac App Store (required for `mas` to install apps from App Store)
4. Copy your public and private SSH keys to `~/.ssh` and make sure they're set to 600
5. Clone this repo to `~/.dotfishy`
6. Run `cd ~/.dotfishy && ./install.sh` to start installation

#### Extra steps
* iTerm - Go to `General` -> `Preferences` -> `Load preferences from custom folder` -> pick `iterm` (cmd+shift+dot to show hidden files)
* Chrome - cVim options https://gist.github.com/jakubdyszkiewicz/f6bbb523c7e383525afa276f9f060680
* Setup IntelliJ settings sync
* Switch Spotlight to Raycast and import the settings

## Updating
* `mise bootstrap --dry-run` / `mise bootstrap plan` - preview what differs from the config
* `mise bootstrap` - apply (or run `./install.sh` again)
* `mise bootstrap packages use brew-cask:foo` - install an app and add it to the config
* `mise bootstrap packages upgrade` - upgrade packages
* `mise dot status` - check dotfile links

## Components

### Packages
* `[bootstrap.packages]`: brew formulae, casks and App Store apps (`mas:<id>`).
* `mise/config.macos.toml` - every Mac, `mise/config.<role>.toml` - per machine.
* `install.sh` runs `mise bootstrap -E macos,<role> --save-env`, so later plain `mise bootstrap` runs remember the layers.
* Removing an entry does not uninstall it: `mise bootstrap packages prune --manager brew --dry-run` lists leftovers.

### Fish + fisher
* Solarized Light Theme
* Fancy Prompt
* [z](https://github.com/rupa/z/)
* [fzf](https://github.com/junegunn/fzf) for `cmd + R`
* Abbreviations for Git

### Git
* Git config
* [add-issue-id-hook](https://github.com/pbetkier/add-issue-id-hook)

### Hammerspoon
* Various modifications.

### iTerm
* Solarized Light Theme

### Karabiner-Elements
* Change Caps Lock to Hyper key
* Change Tilde to left upper corner on non-us Mac keyboards
* Fn + h/j/k/l - navigate mouse, Fn + u/i to scroll

### MacOs
* `[bootstrap.settings.macos]` in `mise/config.toml`.

### Vim
* Solarized Light Theme
* Basic settings to set vim to be usable

### Visual Studio Code
* Solarized Light Theme

### sshrc
Use simple bash config on the remote machine. It sets up:
* Custom prompt
* Lite version of [FZF](https://github.com/jeetsukumaran/fuzzysnake)
* Simple aliases (`..`, `ll`, `la`)

## TODO
* Hammerspoon mods docs
* Solarized Light `bat` theme
* `bat` autocompletion
* automate `xcode-install`?
* Maybe just use [mackup](https://github.com/lra/mackup)? It will sync prefs live using Dropbox

## Thanks to
* [@driesvints](https://github.com/driesvints/dotfiles#a-fresh-os-x-setup) for setting up section