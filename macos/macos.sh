#!/bin/sh

# Fix font rendering on Mojave
defaults write -g CGFontRenderingFontSmoothingDisabled -bool FALSE

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Dock size
defaults write com.apple.dock tilesize -integer 32; killall Dock