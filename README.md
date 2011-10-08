# Simple Ruby Version Management: rbenv

rbenv lets you easily switch between multiple versions of Ruby. It's
simple, unobtrusive, and follows the UNIX tradition of single-purpose
tools that do one thing well.

<img src="http://i.sstephenson.us/rbenv.png" width="894" height="464">

### rbenv _does…_

* Let you **change the global Ruby version** on a per-user basis.
* Provide support for **per-project Ruby versions**.
* Allow you to **override the Ruby version** with an environment
  variable.

### In contrast with rvm, rbenv _does not…_

* **Need to be loaded into your shell.** Instead, rbenv's shim
    approach works by adding a directory to your `$PATH`.
* **Override shell commands like `cd`.** That's dangerous and
    error-prone.
* **Have a configuration file.** There's nothing to configure except
    which version of Ruby you want to use.
* **Install Ruby.** You can build and install Ruby yourself, or use
    [ruby-build](https://github.com/sstephenson/ruby-build) to
    automate the process.
* **Manage gemsets.** [Bundler](http://gembundler.com/) is a better
    way to manage application dependencies. If you have projects that
    are not yet using Bundler you can install the
    [rbenv-gemset](https://github.com/jamis/rbenv-gemset) plugin.
* **Require changes to Ruby libraries for compatibility.** The
    simplicity of rbenv means as long as it's in your `$PATH`,
    [nothing](https://rvm.beginrescueend.com/integration/bundler/)
    [else](https://rvm.beginrescueend.com/integration/capistrano/)
    needs to know about it.
* **Prompt you with warnings when you switch to a project.** Instead
    of executing arbitrary code, rbenv reads just the version name
    from each project. There's nothing to "trust."

## Table of Contents

   * [1 How It Works](#section_1)
   * [2 Installation](#section_2)
      * [2.1 Basic GitHub Checkout](#section_2.1)
         * [2.1.1 Upgrading](#section_2.1.1)
      * [2.2 Homebrew on Mac OS X](#section_2.2)
      * [2.3 Neckbeard Configuration](#section_2.3)
   * [3 Usage](#section_3)
      * [3.1 rbenv global](#section_3.1)
      * [3.2 rbenv local](#section_3.2)
      * [3.3 rbenv shell](#section_3.3)
      * [3.4 rbenv versions](#section_3.4)
      * [3.5 rbenv version](#section_3.5)
      * [3.6 rbenv rehash](#section_3.6)
      * [3.7 rbenv which](#section_3.7)
      * [3.8 rbenv whence](#section_3.8)
   * [4 Development](#section_4)
      * [4.1 Version History](#section_4.1)
      * [4.2 License](#section_4.2)

## <a name="section_1"></a> 1 How It Works

rbenv operates on the per-user directory `~/.rbenv`. Version names in
rbenv correspond to subdirectories of `~/.rbenv/versions`. For
example, you might have `~/.rbenv/versions/1.8.7-p354` and
`~/.rbenv/versions/1.9.3-rc1`.

Each version is a working tree with its own binaries, like
`~/.rbenv/versions/1.8.7-p354/bin/ruby` and
`~/.rbenv/versions/1.9.3-rc1/bin/irb`. rbenv makes _shim binaries_
for every such binary across all installed versions of Ruby.

These shims are simple wrapper scripts that live in `~/.rbenv/shims`
and detect which Ruby version you want to use. They insert the
directory for the selected version at the beginning of your `$PATH`
and then execute the corresponding binary.

Because of the simplicity of the shim approach, all you need to use
rbenv is `~/.rbenv/shims` in your `$PATH`.

## <a name="section_2"></a> 2 Installation

**Compatibility note**: rbenv is _incompatible_ with rvm. Things will
  appear to work until you try to install a gem. The problem is that
  rvm actually overrides the `gem` command with a shell function!
  Please remove any references to rvm before using rbenv.

### <a name="section_2.1"></a> 2.1 Basic GitHub Checkout

This will get you going with the latest version of rbenv and make it
easy to fork and contribute any changes back upstream.

1. Check out rbenv into `~/.rbenv`.

        $ cd
        $ git clone git://github.com/sstephenson/rbenv.git .rbenv

2. Add `~/.rbenv/bin` to your `$PATH` for access to the `rbenv`
   command-line utility.

        $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile

    **Zsh note**: Modifiy your `~/.zshrc` file instead of `~/.bash_profile`.

3. Add rbenv init to your shell to enable shims and autocompletion.

        $ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

    **Zsh note**: Modifiy your `~/.zshrc` file instead of `~/.bash_profile`.

4. Restart your shell so the path changes take effect. You can now
   begin using rbenv.

        $ exec $SHELL

5. Install Ruby versions into `~/.rbenv/versions`. For example, to
   install Ruby 1.9.2-p290, download and unpack the source, then run:

        $ ./configure --prefix=$HOME/.rbenv/versions/1.9.2-p290
        $ make
        $ make install

    The [ruby-build](https://github.com/sstephenson/ruby-build) project
    provides an `rbenv-install` command that simplifies the process of
    installing new Ruby versions to:

        $ rbenv-install 1.9.2-p290

6. Rebuild the shim binaries. You should do this any time you install
   a new Ruby binary (for example, when installing a new Ruby version,
   or when installing a gem that provides a binary).

        $ rbenv rehash

#### <a name="section_2.1.1"></a> 2.1.1 Upgrading

If you've installed rbenv using the instructions above, you can
upgrade your installation at any time using git.

To upgrade to the latest development version of rbenv, use `git pull`:

    $ cd ~/.rbenv
    $ git pull

To upgrade to a specific release of rbenv, check out the corresponding
tag:

    $ cd ~/.rbenv
    $ git fetch
    $ git tag
    v0.1.0
    v0.1.1
    v0.1.2
    v0.2.0
    $ git checkout v0.2.0

### <a name="section_2.2"></a> 2.2 Homebrew on Mac OS X

You can also install rbenv using the
[Homebrew](http://mxcl.github.com/homebrew/) package manager on Mac OS
X.

    $ brew update
    $ brew install rbenv
    $ brew install ruby-build

The same commands can be used for upgrading.

Afterwards you'll still need to add `eval "$(rbenv init -)"` to your
profile as stated in the caveats. You'll only ever have to do this
once.

### <a name="section_2.3"></a> 2.3 Neckbeard Configuration

Skip this section unless you must know what every line in your shell
profile is doing.

`rbenv init` is the only command that crosses the line of loading
extra commands into your shell. Coming from rvm, some of you might be
opposed to this idea. Here's what `rbenv init` actually does:

1. Sets up your shims path. This is the only requirement for rbenv to
   function properly. You can do this by hand by prepending
   `~/.rbenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.rbenv/completions/rbenv.bash` will set that
   up. There is also a `~/.rbenv/completions/rbenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this on init makes sure everything is up to
   date. You can always run `rbenv rehash` manually.

4. Installs the sh dispatcher. This bit is also optional, but allows
   rbenv and plugins to change variables in your current shell, making
   commands like `rbenv shell` possible. The sh dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `rbenv` to be a real script rather than a
   shell function, you can safely skip it.

Run `rbenv init -` for yourself to see exactly what happens under the
hood.

## <a name="section_3"></a> 3 Usage

Like `git`, the `rbenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

### <a name="section_3.1"></a> 3.1 rbenv global

Sets the global version of Ruby to be used in all shells by writing
the version name to the `~/.rbenv/version` file. This version can be
overridden by a per-project `.rbenv-version` file, or by setting the
`RBENV_VERSION` environment variable.

    $ rbenv global 1.9.2-p290

The special version name `system` tells rbenv to use the system Ruby
(detected by searching your `$PATH`).

When run without a version number, `rbenv global` reports the
currently configured global version.

### <a name="section_3.2"></a> 3.2 rbenv local

Sets a local per-project Ruby version by writing the version name to
an `.rbenv-version` file in the current directory. This version
overrides the global, and can be overridden itself by setting the
`RBENV_VERSION` environment variable or with the `rbenv shell`
command.

    $ rbenv local rbx-1.2.4

When run without a version number, `rbenv local` reports the currently
configured local version. You can also unset the local version:

    $ rbenv local --unset

### <a name="section_3.3"></a> 3.3 rbenv shell

Sets a shell-specific Ruby version by setting the `RBENV_VERSION`
environment variable in your shell. This version overrides both
project-specific versions and the global version.

    $ rbenv shell jruby-1.6.4

When run without a version number, `rbenv shell` reports the current
value of `RBENV_VERSION`. You can also unset the shell version:

    $ rbenv shell --unset

Note that you'll need rbenv's shell integration enabled (step 3 of
the installation instructions) in order to use this command. If you
prefer not to use shell integration, you may simply set the
`RBENV_VERSION` variable yourself:

    $ export RBENV_VERSION=jruby-1.6.4

### <a name="section_3.4"></a> 3.4 rbenv versions

Lists all Ruby versions known to rbenv, and shows an asterisk next to
the currently active version.

    $ rbenv versions
      1.8.7-p352
      1.9.2-p290
    * 1.9.3-rc1 (set by /Users/sam/.rbenv/global)
      jruby-1.6.4
      rbx-1.2.4
      ree-1.8.7-2011.03

### <a name="section_3.5"></a> 3.5 rbenv version

Displays the currently active Ruby version, along with information on
how it was set.

    $ rbenv version
    1.8.7-p352 (set by /Volumes/37signals/basecamp/.rbenv-version)

### <a name="section_3.6"></a> 3.6 rbenv rehash

Installs shims for all Ruby binaries known to rbenv (i.e.,
`~/.rbenv/versions/*/bin/*`). Run this command after you install a new
version of Ruby, or install a gem that provides binaries.

    $ rbenv rehash

### <a name="section_3.7"></a> 3.7 rbenv which

Displays the full path to the binary that rbenv will execute when you
run the given command.

    $ rbenv which irb
    /Users/sam/.rbenv/versions/1.9.2-p290/bin/irb

### <a name="section_3.8"></a> 3.8 rbenv whence

Lists all Ruby versions with the given command installed.

    $ rbenv whence rackup
    1.9.3-rc1
    jruby-1.6.4
    ree-1.8.7-2011.03

## <a name="section_4"></a> 4 Development

The rbenv source code is [hosted on
GitHub](https://github.com/sstephenson/rbenv). It's clean, modular,
and easy to understand, even if you're not a shell hacker.

Please feel free to submit pull requests and file bugs on the [issue
tracker](https://github.com/sstephenson/rbenv/issues).

### <a name="section_4.1"></a> 4.1 Version History

**0.2.1** (October 1, 2011)

* Changed the `rbenv` command to ensure that `RBENV_DIR` is always an
  absolute path. This fixes an issue where Ruby scripts using the
  `ruby-local-exec` wrapper would go into an infinite loop when
  invoked with a relative path from the command line.

**0.2.0** (September 28, 2011)

* Renamed `rbenv set-default` to `rbenv global` and `rbenv set-local`
  to `rbenv local`. The `set-` commands are deprecated and will be
  removed in the next major release.
* rbenv now uses `greadlink` on Solaris.
* Added a `ruby-local-exec` command which can be used in shebangs in
  place of `#!/usr/bin/env ruby` to properly set the project-specific
  Ruby version regardless of current working directory.
* Fixed an issue with `rbenv rehash` when no binaries are present.
* Added support for `rbenv-sh-*` commands, which run inside the
  current shell instead of in a child process.
* Added an `rbenv shell` command for conveniently setting the
  `$RBENV_VERSION` environment variable.
* Added support for storing rbenv versions and shims in directories
  other than `~/.rbenv` with the `$RBENV_ROOT` environment variable.
* Added support for debugging rbenv via `set -x` when the
  `$RBENV_DEBUG` environment variable is set.
* Refactored the autocompletion system so that completions are now
  built-in to each command and shared between bash and Zsh.
* Added support for plugin bundles in `~/.rbenv/plugins` as documented
  in [issue #102](https://github.com/sstephenson/rbenv/pull/102).
* Added `/usr/local/etc/rbenv.d` to the list of directories searched
  for rbenv hooks.
* Added support for an `$RBENV_DIR` environment variable which
  defaults to the current working directory for specifying where rbenv
  searches for local version files.

**0.1.2** (August 16, 2011)

* Fixed rbenv to be more resilient against nonexistent entries in
  `$PATH`.
* Made the `rbenv rehash` command operate atomically.
* Modified the `rbenv init` script to automatically run `rbenv
  rehash` so that shims are recreated whenever a new shell is opened.
* Added initial support for Zsh autocompletion.
* Removed the dependency on egrep for reading version files.

**0.1.1** (August 14, 2011)

* Fixed a syntax error in the `rbenv help` command.
* Removed `-e` from the shebang in favor of `set -e` at the top of
  each file for compatibility with operating systems that do not
  support more than one argument in the shebang.

**0.1.0** (August 11, 2011)

* Initial public release.

### <a name="section_4.2"></a> 4.2 License

(The MIT license)

Copyright (c) 2011 Sam Stephenson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
