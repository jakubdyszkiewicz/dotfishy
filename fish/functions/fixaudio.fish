function fixaudio
    sudo rm /Library/Preferences/Audio/com.apple.audio.DeviceSettings.plist
    sudo rm /Library/Preferences/Audio/com.apple.audio.SystemSettings.plist
    sudo killall coreaudiod
end
