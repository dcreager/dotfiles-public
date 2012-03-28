# Dotfiles

This is [my](https://github.com/dcreager/) collection of dotfiles.  It's
managed by a [`dotfiles`](https://github.com/dcreager/dotfiles-base/)
script that automatically symlinks files into `$HOME` from multiple
dotfiles repositories.

This collection of dotfiles assumes that you're using the following
tools, which should already be installed on your system:

* [zsh](http://zsh.sourceforge.net/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [git](http://git-scm.com/)
* [git-flow](https://github.com/nvie/gitflow)
* [vim](http://www.vim.org/) and/or
  [MacVIM](http://code.google.com/p/macvim/)

Furthermore, it assumes that oh-my-zsh has been checked out into
`$HOME/.oh-my-zsh` (which is the standard place to put it).

It also includes the following tools in the repository directly, so you
don't need to install them:

* [hub](http://defunkt.io/hub/)

## Installation

To install, you must already have the
[`dotfiles`](https://github.com/dcreager/dotfiles-base/) script
installed.  Then, just run:

    $ cd ~
    $ git clone git://github.com/dcreager/dotfiles-public .dotfiles.dcreager
    $ dotfiles install
    $ reload
