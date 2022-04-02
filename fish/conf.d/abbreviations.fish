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
  abbr grh 'git reset --hard HEAD'

  abbr cls 'clear'
  abbr cx 'chmod +x'

  abbr psg 'ps aux | grep'

  abbr pserv 'python3 -m http.server 8080'

  abbr km 'kumactl'
  abbr kma 'kumactl apply -f'
  abbr pkma 'pbpaste | kumactl apply -f -'

  abbr kc 'kubectl'
  abbr kca 'kubectl apply -f'
  abbr pkca 'pbpaste | kubectl apply -f -'
  abbr ks 'kubens'
  abbr kcp 'kubectl get pods -A'
  abbr kcs 'kubectl get svc -A'

  abbr dps 'docker ps'

  # Kuma & Kong Mesh development
  abbr unit 'time monitor make test'
  abbr e2e 'make k3d/stop/all; dstop; time monitor make -j test/e2e/debug-fast K3D=true E2E_PKG_LIST=./'
  abbr e2eu 'dstop; time monitor make -j test/e2e/debug-universal E2E_PKG_LIST=./'
  abbr pfk 'kubectl port-forward -n kuma-system svc/kuma-control-plane 5681 --address 0.0.0.0'
  abbr pfkm 'kubectl port-forward -n kong-mesh-system svc/kong-mesh-control-plane 5681 --address 0.0.0.0'
  abbr pfdemo 'kubectl port-forward -n kuma-demo svc/demo-app 5000 --address 0.0.0.0'
  abbr pfenvoy 'kubectl port-forward -n kuma-demo (kubectl get pods -n kuma-demo | grep demo-app | cut -d " " -f1) 9901 --address 0.0.0.0'
  abbr logsk 'kubectl logs -n kuma-system deployments/kuma-control-plane -f'
  abbr logskm 'kubectl logs -n kong-mesh-system deployments/kong-mesh-control-plane -f'
  abbr logsdemo 'kubectl logs -n kuma-demo deployments/demo-app -c kuma-sidecar -f'
  abbr kc0 'set -gx KUBECONFIG ~/.kube/kind-kuma-config'
  abbr kc1 'set -gx KUBECONFIG ~/.kube/kind-kuma-1-config'
  abbr kc2 'set -gx KUBECONFIG ~/.kube/kind-kuma-2-config'

#end
