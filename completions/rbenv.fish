function __fish_rbenv
  rbenv commands
end

complete -f -c rbenv -a '(__fish_rbenv)'
