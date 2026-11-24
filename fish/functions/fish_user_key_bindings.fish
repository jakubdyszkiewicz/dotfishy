function fish_user_key_bindings
  # fzf comes from mise; it ships its own fish integration
  command -q fzf; and fzf --fish | source
end
