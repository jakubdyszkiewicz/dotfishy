#set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home
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

set -gx Z_DATA $HOME/.local/share/z/data
set -gx Z_DATA_DIR $HOME/.local/share/z
set -gx Z_EXCLUDE \x5e/$HOME\x24

set fish_greeting # disable intro message

# Rewrite Fisher installation path to not mix my files with Fisher files
set -g fisher_path $HOME/.config/fish/fisher

set -p fish_function_path fish_function_path[1] $fisher_path/functions
set -p fish_complete_path fish_complete_path[1] $fisher_path/completions

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2>/dev/null
end

# Created by `pipx` on 2024-12-19 19:36:02
set PATH $PATH /Users/jakub/.local/bin
