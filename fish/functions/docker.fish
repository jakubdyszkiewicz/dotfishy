alias dstop="docker stop (docker ps -a -q)"
alias drm="docker stop (docker ps -a -q); docker rm (docker ps -a -q)"
alias dprune="docker system prune -a"
alias dexec="docker exec -ti"
alias dsh="docker exec -ti $argv[1] /bin/sh"
function dsh
    docker exec -ti $argv[1] /bin/sh
end
function dbash
    docker exec -ti $argv[1] /bin/bash
end