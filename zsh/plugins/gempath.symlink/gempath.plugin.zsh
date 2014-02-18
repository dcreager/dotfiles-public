if which ruby >/dev/null 2>/dev/null; then
    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
    path=($GEM_HOME/bin $path)
fi
