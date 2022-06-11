#!/bin/bash
rootDir=`pwd`

# Links file if not linked alreday. If there is file, it asks whether to replace it
link_file () {
    src=$1
    dst=$2
    dst_dir=`dirname "$dst"`
    mkdir -p $dst_dir
    echo $dst
    if [ -e "$dst" ]; then
        if [ `readlink "$dst"` = "$src" ]; then
            echo "$src is already linked to $dst"
        else
            read -p "$dst already exist. Replace it (y/[N])? " answer
            case ${answer:0:1} in
                y|Y )
                    echo "Removing $dst"
                    rm -rf "$dst"
                    echo "Linking $src to $dst"
                    ln -s "$src" "$dst"
                ;;
                * )
                    echo "$dst not replaced"
                ;;
            esac
        fi
    else
        echo "Linking $src to $dst"
        ln -s "$src" "${dst}"
    fi
}

echo "> Install dotfiles"
echo ""

echo ">> Install Homebrew component"
if ! which brew > /dev/null; then
    echo ">>> Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo ">>> Homebrew already installed. Running: brew update"
    brew update
fi
echo ""
echo ">>> Install brews from Brewfile"
cd $rootDir/brew
brew bundle
cd $rootDir

echo ">> Apply fish shell"
currentShell=`basename $SHELL`
if [ $currentShell != 'fish' ]; then
    if grep -q "/usr/local/bin/fish" "/etc/shells"; then
        echo "Fish already in /etc/shells"
    else
        echo "Adding fish to /etc/shells (requires sudo)"
        sudo "/usr/local/bin/fish" >> "/etc/shells"
        echo "Changing shell to fish"
        chsh --shell $(which fish)
    fi
else
    echo "Fish already set as default shell"
fi

echo ">> Install Fish component"
link_file $rootDir/fish ~/.config/fish
link_file $rootDir/omf ~/.config/omf
# echo ">>> Update oh-my-fish"
# omf install
echo ""

echo ">> Install MacOS component"
bash $rootDir/macos/macos.sh

echo ">> Install Hammerspoon component"
link_file $rootDir/hammerspoon ~/.hammerspoon
echo ""

echo ">> Install Karabiner component"
link_file $rootDir/karabiner ~/.config/karabiner
echo ""

echo ">> Install BetterTouchTools component"
link_file $rootDir/bettertouchtool/.btt_autoload_preset.json ~/.btt_autoload_preset.json
echo ""

echo ">> Install Git component"
echo ">>> Install gitconfig"
link_file $rootDir/git/gitconfig ~/.gitconfig

echo ">>> Install commit-msg hook"
link_file $rootDir/git/commit-msg ~/.git-templates/hooks/commit-msg
echo ">>>> Change git's init.templatedir to include ~/.git-templates"
git config --global init.templatedir ~/.git-templates

echo ">> Install Vim"
link_file $rootDir/vim/vimrc ~/.vimrc
link_file $rootDir/vim/solarized.vim ~/.vim/colors/solarized.vim

echo ">> Installing Visual Studio Code settings"
link_file $rootDir/vscode/settings.json "$HOME/Library/Application Support/Code/User/settings.json"

echo ">> Install sshrc"
link_file $rootDir/sshrc/.sshrc ~/.sshrc
link_file $rootDir/sshrc/.sshrc.d ~/.sshrc.d

echo ">>> Install FZF completion for fish"
/opt/Homebrew/opt/fzf/install