set -gx PATH /usr/local/bin $PATH 
set -gx PATH /opt/homebrew/bin $PATH
set -gx PATH $HOME/bin $PATH
set -gx KUMA_REPORTS_ENABLED false
set -gx PATH $HOME/kong/kuma/build/artifacts-darwin-amd64/kumactl/ $PATH
set -gx PATH $HOME/kong/kuma/build/artifacts-darwin-amd64/kuma-dp/ $PATH
set -gx PATH $HOME/kong/kuma/build/artifacts-darwin-amd64/kuma-cp/ $PATH
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH
set -gx CLOUDSDK_PYTHON python2
alias c="bat"
alias python="python3"

set -gx __kube_ps_enabled 1

set fish_greeting # disable intro message

# machine specific config
set -l profile_file ~/.dotfishy/profile
if test -f $profile_file
    set -l profile (string trim -- (cat $profile_file))
    switch $profile
        case work
            source ~/.config/fish/profiles/work.fish
        case priv
            source ~/.config/fish/profiles/priv.fish
    end
end

# Created by `pipx` on 2024-12-19 19:36:02
set PATH $PATH /Users/jakub/.local/bin

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/jakub/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
