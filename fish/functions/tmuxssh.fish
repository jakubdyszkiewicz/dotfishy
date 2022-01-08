# Usage: tmuxssh user@hostname
# tmuxssh creates an ssh connection and connects or creates tmux session
function tmuxssh
    ssh "$argv[1]" -t 'tmux -2 -CC new-session -A -s main'
end