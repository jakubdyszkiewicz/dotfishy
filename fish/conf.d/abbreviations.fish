#if not set -q abbrs_initialized
#  set -U abbrs_initialized

  abbr g 'git'
  abbr ga 'git add'
  abbr gb 'git branch -a'
  abbr gbl 'git blame'
  abbr gc 'git checkout'
  abbr gcm 'git commit -m'
  abbr gca 'git commit --amend'
  abbr gco 'git checkout'
  abbr gcp 'git cherry-pick'
  abbr gd 'git diff'
  abbr gf 'git fetch'
  abbr gl 'git llog'
  abbr gm 'git merge'
  abbr gp 'git push'
  abbr gpl 'git pull'
  abbr gr 'git remote'
  abbr gs 'git status'
  abbr gst 'git stash'
  abbr gbi 'git rebase --interactive'
  abbr gro 'git reset --hard origin/master'

  abbr cls 'clear'
  abbr cx 'chmod +x'

  abbr postgres_start 'pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
  abbr postgres_stop 'pg_ctl -D /usr/local/var/postgres stop -s -m fast'

  abbr psg 'ps aux | grep'

  abbr pserv 'python -m SimpleHTTPServer 8080'

  abbr km 'kumactl'
  abbr kma 'kumactl apply -f'
  abbr kc 'kubectl'
  abbr kca 'kubectl apply -f'
  abbr ks 'kubens'
  abbr kcp 'kubectl get pods --all-namespaces'
#end
