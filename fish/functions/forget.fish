function forget
  for host in $argv
    sed -i.bak "/$host/d" ~/.ssh/known_hosts
  end
end
