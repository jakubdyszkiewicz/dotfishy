#!/bin/bash

echo "🕺 Provisioning remote dev machine..."

echo "🤞 Installing various crap"

apt update
apt install -y \
  git \
  make \
  tmux \
  docker.io \
  clang-format \
  unzip \
  fish \
  fzf \
  build-essential

if [ ! -f /usr/local/go/bin/go ]; then
    echo "🤞 Let's install Go"
    cd /tmp
    wget https://go.dev/dl/go1.17.4.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.17.4.linux-amd64.tar.gz
    ln -s /usr/local/go/bin/go /usr/local/bin/go
    echo "😎 Go installed"
else
    echo "😎 Go already installed"
fi

cd /tmp/
git clone https://github.com/jakubdyszkiewicz/dotfishy
mkdir -p ~/.config/fish
cp -R dotfishy/fish/* ~/.config/fish

currentShell=`basename $SHELL`
if [ $currentShell != 'fish' ]; then
    if grep -q "/usr/local/bin/fish" "/etc/shells"; then
        echo "✅ Fish already in /etc/shells"
    else
        echo "Adding fish to /etc/shells"
        echo "/usr/local/bin/fish" >> "/etc/shells"
        echo "Changing shell to fish"
        chsh --shell $(which fish)
    fi
else
    echo "😎 Fish already set as default shell"
fi
