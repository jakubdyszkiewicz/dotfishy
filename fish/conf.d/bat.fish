# ansi: use the terminal's palette (Everforest in iTerm); bat has no built-in Everforest
alias bat 'bat --theme=ansi --style="numbers,changes"'
complete -c bat -a '(__fish_complete_path)'
