# Activate mise: puts [tools] from ~/.config/mise (and project mise.toml files) on PATH.
# Absolute paths because conf.d runs before config.fish sets up PATH.
for mise_bin in /opt/homebrew/bin/mise /usr/bin/mise ~/.local/bin/mise
    if test -x $mise_bin
        if status is-interactive
            $mise_bin activate fish | source
        else
            $mise_bin activate fish --shims | source
        end
        break
    end
end
set -e mise_bin
