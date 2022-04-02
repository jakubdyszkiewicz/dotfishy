# Usage:
# set -gx MONITOR_HOST localhost
# monitor sleep 10
# The command will first set anybar to green and then reset to hollow
function monitor
    set -q MONITOR_HOST || set MONITOR_HOST localhost
    echo -n "green" | nc -4u -w0 $MONITOR_HOST 1738
    eval $argv
    echo -n "hollow" | nc -4u -w0 $MONITOR_HOST 1738
end