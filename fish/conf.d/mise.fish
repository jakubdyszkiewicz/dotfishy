# Activate mise: puts [tools] from ~/.config/mise/config.toml (and project mise.toml files) on PATH.
# Absolute path because conf.d runs before config.fish adds /opt/homebrew/bin to PATH.
if status is-interactive; and test -x /opt/homebrew/bin/mise
    /opt/homebrew/bin/mise activate fish | source
else if test -x /opt/homebrew/bin/mise
    /opt/homebrew/bin/mise activate fish --shims | source
end
