# Activate mise: puts [tools] from ~/.config/mise (and project mise.toml files) on PATH.
# Absolute paths because conf.d runs before config.fish sets up PATH.
# PATH order after activation: mise tools, ~/.local/bin (own builds, pipx, uv), Homebrew, system.
# Set here, before activation, so mise ends up in front (config.fish runs later and must
# not prepend these again). -m moves an entry that is already on PATH.
fish_add_path -gm /opt/homebrew/bin /opt/homebrew/sbin
fish_add_path -gm ~/.local/bin
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
