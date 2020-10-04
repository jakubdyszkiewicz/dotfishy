#set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home
set -gx PATH /usr/local/bin $PATH 
set -gx PATH $HOME/bin $PATH
set -gx KUMA_REPORTS_ENABLED false
set -gx PATH $HOME/kong/kuma/build/artifacts-darwin-amd64/kumactl/ $PATH
set -gx PATH $HOME/kong/kuma/build/artifacts-darwin-amd64/kuma-dp/ $PATH
set -gx GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH
alias c="bat"

set fish_greeting # disable intro message

# Rewrite Fisher installation path to not mix my files with Fisher files
set -g fisher_path $HOME/.config/fish/fisher

set -p fish_function_path fish_function_path[1] $fisher_path/functions
set -p fish_complete_path fish_complete_path[1] $fisher_path/completions

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2>/dev/null
end
