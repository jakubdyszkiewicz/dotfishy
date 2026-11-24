# Activate mise: puts [tools] from ~/.config/mise (and project mise.toml files) on PATH.
# Absolute paths because conf.d runs before config.fish sets up PATH.
# Homebrew goes on PATH here, before activation, so mise tools end up in front of it
# (config.fish runs later and must not prepend /opt/homebrew/bin again).
fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin
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
