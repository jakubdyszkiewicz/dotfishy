#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title ant dns
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Change DNS to ant services

networksetup -setdnsservers Wi-Fi 192.168.1.52
echo "DNS Changed"

