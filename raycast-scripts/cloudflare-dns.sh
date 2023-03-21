#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title cloudflare dns
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Change DNS to Cloudflare DNS

networksetup -setdnsservers Wi-Fi 1.1.1.1
echo "DNS Changed"


