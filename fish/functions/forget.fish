# When IP of machine changes there is warning about ssh fingerprint and you cannot log into machine. Execute `forget ip` to reset this machine from known_hosts
function forget
  for host in $argv
    sed -i.bak "/$host/d" ~/.ssh/known_hosts
  end
end
