#!/bin/bash

echo "🕺 Provisioning remote dev machine..."

echo "🤞 Installing various crap"

apt update
apt install -y \
  openjdk-8-jre-headless \
  git \
  make \
  tmux \
  docker.io \
  clang-format \
  watchman \
  unzip \
  fish \
  fzf \
  build-essential

if [ ! -f /opt/mirror/mirror ]; then
    echo "🤞 Let's install Mirror"
    mkdir -p /opt/mirror
    wget https://github.com/stephenh/mirror/releases/latest/download/mirror-all.jar -O /opt/mirror/mirror-all.jar
    wget https://github.com/stephenh/mirror/releases/latest/download/mirror -O /opt/mirror/mirror
    chmod u+x /opt/mirror/mirror

    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
    echo fs.inotify.max_queued_events=50000 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

    serviceDef="
[Unit]
Description=Mirror service

[Service]
Type=simple
User=root
ExecStart=/opt/mirror/mirror server

[Install]
WantedBy=multi-user.target
"
    echo "$serviceDef" > /etc/systemd/system/mirror.service
    chmod 644 /etc/systemd/system/mirror.service

    systemctl start mirror
    systemctl enable mirror
    echo "😎 Mirror installed"
else
    echo "😎 Mirror already installed"
fi

if [ ! -f /usr/local/go/bin/go ]; then
    echo "🤞 Let's install Go"
    cd /tmp
    wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
    tar -xvf go1.15.2.linux-amd64.tar.gz
    mv go /usr/local

    if ! grep -q GOROOT "$HOME/.bashrc"; then
        echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
        echo 'export GOPATH=$HOME/go' >> $HOME/.profile
        echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.profile
    fi
    echo "😎 Go installed"
else
    echo "😎 Go already installed"
fi

currentShell=`basename $SHELL`
if [ $currentShell != 'fish' ]; then
    if grep -q "/usr/local/bin/fish" "/etc/shells"; then
        echo "✅ Fish already in /etc/shells"
    else
        echo "Adding fish to /etc/shells (requires sudo)"
        sudo "/usr/local/bin/fish" >> "/etc/shells"
        echo "Changing shell to fish"
        chsh --shell $(which fish)
    fi
else
    echo "😎 Fish already set as default shell"
fi

# if [ ! -d $HOME/.config/omf ]; then
#     echo "🤞 Let's install OMF"
#     curl -L https://get.oh-my.fish | fish
#     echo "package z" >> $HOME/.config/omf/bundleF
#     echo "theme simple-ass-prompt" >> $HOME/.config/omf/bundle
#     omf install
#     omf theme simple-ass-prompt
# else
#     echo "😎 OMF already installed"
# fi