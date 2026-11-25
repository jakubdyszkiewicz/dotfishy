function fish_user_key_bindings
  # fzf comes from mise; it ships its own fish integration
  # fzf's fish integration needs fish >= 3.4 (Ubuntu 22.04 ships 3.3)
  if command -q fzf; and not string match -qr -- '^[12]\.|^3\.[0-3]\.' $version
    fzf --fish | source
  end
end
