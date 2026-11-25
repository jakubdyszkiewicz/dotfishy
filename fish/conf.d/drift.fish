# Drift reminder: shows the last result of mise/scripts/drift.sh when a shell starts and
# refreshes it in the background at most once a day (`mise run dotfishy:drift` refreshes it too).
status is-interactive; or exit
set -l drift_cache ~/.cache/dotfishy-drift
set -l drift_script ~/.dotfishy/mise/scripts/drift.sh
test -x $drift_script; or exit

if test -s $drift_cache
    set_color yellow
    cat $drift_cache
    echo
    set_color normal
end

set -l mtime (date -r $drift_cache +%s 2>/dev/null; or echo 0) # works with BSD (macOS) and GNU date
if test (math (date +%s) - $mtime) -gt 86400
    touch $drift_cache # don't start another check from the next shell while this one runs
    bash $drift_script --summary > /dev/null 2>&1 &
    disown
end
