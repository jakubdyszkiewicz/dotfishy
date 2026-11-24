#!/bin/bash
# Sets up this Mac from ~/.dotfishy. Safe to re-run.
# Everything except installing Homebrew + mise is declared in mise/config.toml.
set -euo pipefail
rootDir="$(cd "$(dirname "$0")" && pwd)"

echo ">> Homebrew"
if ! command -v brew > /dev/null && [ ! -x /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo ">> mise"
command -v mise > /dev/null || brew install mise

echo ">> Link ~/.config/mise -> $rootDir/mise"
if [ "$(readlink ~/.config/mise || true)" != "$rootDir/mise" ]; then
    if [ -e ~/.config/mise ]; then
        backup=~/.config/mise.backup.$(date +%Y%m%d%H%M%S)
        echo "Moving existing ~/.config/mise to $backup"
        mv ~/.config/mise "$backup"
    fi
    mkdir -p ~/.config
    ln -s "$rootDir/mise" ~/.config/mise
fi

for f in "$rootDir"/mise/config*.toml; do mise trust "$f"; done

# Machine role (priv/work/mini), also read by fish and Hammerspoon. Selects mise/config.<role>.toml
# on top of config.macos.toml and config.dev.toml (every Mac is a dev machine).
# Linux boxes are set up by ant-hill (Ansible), not this script.
profile="$(tr -d '[:space:]' < "$rootDir/profile" 2>/dev/null || true)"
if [ -z "$profile" ]; then
    read -r -p "Role of this Mac (priv/work/mini): " profile
    echo "$profile" > "$rootDir/profile"
fi
envs="macos,dev${profile:+,$profile}"

echo ">> mise bootstrap -E $envs (packages, dotfiles, macOS defaults, login shell, tools)"
mise bootstrap -E "$envs" --save-env "$@"
