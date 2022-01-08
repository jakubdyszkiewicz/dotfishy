# Usage: tmuxssh user@hostname
# tmuxssh creates an ssh connection and connects or creates tmux session
function tmuxssh
    ssh "$argv[1]" -t 'export TERM=xterm-256color; tmux -CC new-session -A -s main'
end