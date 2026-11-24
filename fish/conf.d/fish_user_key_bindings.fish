function fish_user_key_bindings
  # fzf comes from mise; it ships its own fish integration
  command -q fzf; and fzf --fish | source
  fish_vi_key_bindings
end
