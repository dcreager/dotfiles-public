# Dotfiles

This is [my](https://github.com/dcreager/) collection of dotfiles.  It's
managed by a [`dotfiles`](https://github.com/dcreager/dotfiles-base/)
script that automatically symlinks files into `$HOME` from multiple
dotfiles repositories.

## Installation

To install, you must already have the
[`dotfiles`](https://github.com/dcreager/dotfiles-base/) script
installed.  Then, just run:

    $ cd ~
    $ git clone git://github.com/dcreager/dotfiles-public .dotfiles.dcreager
    $ dotfiles install
    $ reload
