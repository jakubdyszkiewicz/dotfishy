function n
  set -l content "aaaaand. It's done!"
  if test (count $argv) = 1
    set content $argv[1]
  end
  echo $content > /tmp/test
end