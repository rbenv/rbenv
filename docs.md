---
layout: default
permalink: /docs/
---

### Command Reference

Like `git`, the `rbenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

##### rbenv local

Sets a local application-specific Ruby version by writing the version
name to a `.ruby-version` file in the current directory. This version
overrides the global version, and can be overridden itself by setting
the `RBENV_VERSION` environment variable or with the `rbenv shell`
command.

    $ rbenv local 1.9.3-p327

When run without a version number, `rbenv local` reports the currently
configured local version. You can also unset the local version:

    $ rbenv local --unset

##### rbenv global

Sets the global version of Ruby to be used in all shells by writing
the version name to the `~/.rbenv/version` file. This version can be
overridden by an application-specific `.ruby-version` file, or by
setting the `RBENV_VERSION` environment variable.

    $ rbenv global 1.8.7-p352

The special version name `system` tells rbenv to use the system Ruby
(detected by searching your `$PATH`).

When run without a version number, `rbenv global` reports the
currently configured global version.

##### rbenv shell

Sets a shell-specific Ruby version by setting the `RBENV_VERSION`
environment variable in your shell. This version overrides
application-specific versions and the global version.

    $ rbenv shell jruby-1.7.1

When run without a version number, `rbenv shell` reports the current
value of `RBENV_VERSION`. You can also unset the shell version:

    $ rbenv shell --unset

Note that you'll need rbenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`RBENV_VERSION` variable yourself:

    $ export RBENV_VERSION=jruby-1.7.1

##### rbenv versions

Lists all Ruby versions known to rbenv, and shows an asterisk next to
the currently active version.

    $ rbenv versions
      1.8.7-p352
      1.9.2-p290
    * 1.9.3-p327 (set by /Users/sam/.rbenv/version)
      jruby-1.7.1
      rbx-1.2.4
      ree-1.8.7-2011.03

##### rbenv version

Displays the currently active Ruby version, along with information on
how it was set.

    $ rbenv version
    1.9.3-p327 (set by /Users/sam/.rbenv/version)

##### rbenv rehash

Installs shims for all Ruby executables known to rbenv (i.e.,
`~/.rbenv/versions/*/bin/*`). Run this command after you install a new
version of Ruby, or install a gem that provides commands.

    $ rbenv rehash

##### rbenv which

Displays the full path to the executable that rbenv will invoke when
you run the given command.

    $ rbenv which irb
    /Users/sam/.rbenv/versions/1.9.3-p327/bin/irb

##### rbenv whence

Lists all Ruby versions with the given command installed.

    $ rbenv whence rackup
    1.9.3-p327
    jruby-1.7.1
    ree-1.8.7-2011.03
