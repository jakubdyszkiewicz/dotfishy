#!/bin/bash
# Sets up this machine (macOS or Ubuntu) from ~/.dotfishy. Safe to re-run.
# Everything except installing mise (and Homebrew on macOS) is declared in mise/config*.toml.
# Boxes provisioned by ant-hill (Ansible) use its dotfiles role instead of this script.
set -euo pipefail
rootDir="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
    Darwin) os=macos ;;
    Linux) os=linux ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

if [ "$os" = macos ]; then
    echo ">> Homebrew"
    if ! command -v brew > /dev/null && [ ! -x /opt/homebrew/bin/brew ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"

    echo ">> mise"
    command -v mise > /dev/null || brew install mise
else
    echo ">> mise"
    export PATH="$HOME/.local/bin:$PATH"
    if ! command -v mise > /dev/null; then
        # Installs to ~/.local/bin/mise; update it later with `mise self-update`.
        curl -fsSL https://mise.run | MISE_VERSION="${MISE_VERSION:-2026.11.12}" sh
    fi
fi

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

# Machine role, also read by fish and Hammerspoon. Selects mise/config.<role>.toml.
#   macOS: priv / work / mini, on top of config.macos.toml and config.dev.toml (every Mac is a dev machine)
#   Linux: dev, or empty for a server, on top of config.linux.toml
if [ ! -f "$rootDir/profile" ]; then
    if [ "$os" = macos ]; then
        read -r -p "Role of this Mac (priv/work/mini): " role
    else
        read -r -p "Role of this Linux box (dev, or empty for a server): " role
    fi
    echo "$role" > "$rootDir/profile"
fi
profile="$(tr -d '[:space:]' < "$rootDir/profile")"
if [ "$os" = macos ]; then
    envs="macos,dev${profile:+,$profile}"
else
    envs="linux${profile:+,$profile}"
    # mise installs apt packages with sudo; refresh the index first (a fresh box has none).
    # Not `mise bootstrap --update`: that also fast-forwards this git checkout.
    if [ "$(id -u)" -eq 0 ]; then apt-get update; else sudo apt-get update; fi
fi

echo ">> mise bootstrap -E $envs (packages, dotfiles, settings, login shell, tools)"
mise bootstrap -E "$envs" --save-env "$@"
