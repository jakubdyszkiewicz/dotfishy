# dot-🐟-y (my dotfiles)
Since new Macbooks are so fragile, I've created repo to setup my Mac faster.
It installs [Fish](https://fishshell.com/) as a shell and the [Everforest](https://github.com/sainnhe/everforest) dark theme across apps.
The killer feature is the [Hyper key](http://brettterpstra.com/2012/12/08/a-useful-caps-lock-key/) config with lots of shortcuts.

![iTerm](https://i.imgur.com/StrxYCA.png)

## How it works
Everything is declared in [`mise/`](mise/) and applied with [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html):
packages, dotfile symlinks, macOS defaults, login shell and dev tools. `~/.config/mise` is a symlink to `~/.dotfishy/mise`.

Each machine loads `mise/config.toml` plus layers: an OS (`macos`/`linux`), `dev` for development machines (go, node, java, rust, cmake, coding agents) and a role:

| Machine | Set up by | `-E` | Gets |
|---|---|---|---|
| Private MacBook | `install.sh` | `macos,dev,priv` | everything Mac + private apps |
| Work MacBook | `install.sh` | `macos,dev,work` | everything Mac + work apps |
| Mac mini (build server) | `install.sh` | `macos,dev,mini` | everything Mac + power settings task |
| ant-dev | [ant-hill](https://github.com/jakubdyszkiewicz/ant-hill) | `linux,dev` | apt packages, dotfiles, CLI tools + dev tools |
| ant-services, ant-hill | [ant-hill](https://github.com/jakubdyszkiewicz/ant-hill) | `linux` | apt packages, dotfiles, CLI tools |
| Any other Ubuntu box | `install.sh` | `linux` or `linux,dev` | same as above, plus fish as login shell |

With `install.sh` the role comes from the gitignored `profile` file (also read by fish and Hammerspoon).
CLI tools (fzf, gh, bat, jq, sift) are mise `[tools]` in `config.toml`: same pinned versions on every machine.
On Linux, Ansible installs git + mise, clones this repo, runs `mise bootstrap --only packages` as root
(the `apt:` entries in `config.linux.toml`) and `--only dotfiles,tools` as the user; users, services etc. stay in Ansible.
Dev machines get Docker from `config.dev.toml`; servers that run containers in production (ant-services) get it from Ansible.

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

## A fresh Ubuntu box (not managed by ant-hill)
Needs `git` and `curl` (both preinstalled on Ubuntu).
```sh
git clone https://github.com/jakubdyszkiewicz/dotfishy ~/.dotfishy && ~/.dotfishy/install.sh
```
It asks for the role (`dev`, or empty for a server), installs mise to `~/.local/bin`,
installs the apt packages (with sudo), links the dotfiles, installs the tools and switches the login shell to fish.

## Updating
* `mise bootstrap --dry-run` / `mise bootstrap plan` - preview what differs from the config
* `mise bootstrap` - apply (or run `./install.sh` again)
* `mise bootstrap packages use brew-cask:foo` - install an app and add it to the config
* `mise bootstrap packages upgrade` - upgrade packages
* `mise dot status` - check dotfile links
* `mise run dotfishy:drift` - what's not committed or declared yet: repo changes, hand-installed brew/cask/App Store packages, replaced dotfile links. New shells show a one-line reminder (checked in the background once a day).

## Components

### Packages
* `[bootstrap.packages]`: brew formulae, casks and App Store apps (`mas:<id>`).
* `mise/config.macos.toml` - every Mac, `mise/config.<role>.toml` - per machine.
* `install.sh` runs `mise bootstrap -E macos,dev,<role> --save-env`, so later mise commands (and the shell) use the same layers.
* Removing an entry does not uninstall it: `mise bootstrap packages prune --manager brew --dry-run` lists leftovers.

### Fish + fisher
* Everforest Dark colors
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
* Everforest Dark colors

### Karabiner-Elements
* Change Caps Lock to Hyper key
* Change Tilde to left upper corner on non-us Mac keyboards
* Fn + h/j/k/l - navigate mouse, Fn + u/i to scroll

### MacOs
* `[bootstrap.settings.macos]` in `mise/config.toml`.

### Vim
* Everforest theme (vendored in `vim/pack/themes`)
* Basic settings to set vim to be usable

### Visual Studio Code
* Everforest Complete Dark theme

### sshrc
Use simple bash config on the remote machine. It sets up:
* Custom prompt
* Lite version of [FZF](https://github.com/jeetsukumaran/fuzzysnake)
* Simple aliases (`..`, `ll`, `la`)

## TODO
* Hammerspoon mods docs
* `bat` autocompletion
* automate `xcode-install`?
* Maybe just use [mackup](https://github.com/lra/mackup)? It will sync prefs live using Dropbox

## Thanks to
* [@driesvints](https://github.com/driesvints/dotfiles#a-fresh-os-x-setup) for setting up section