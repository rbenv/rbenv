Manage Your Enviroment with *rbenv*
===
`rbenv` is a version manager tool for the Ruby programming language on Unix-like systems. It is useful for switching between multiple Ruby versions on the same machine and for ensuring that each project you are working on always runs on the correct Ruby version.

# TABLE OF CONTENTS
 - [Install rbenv](#installation)
   - [Using a Distro Package Manager](#USING-A-DISTRO-PACKAGE-MANAGER)
     - [Homebrew](#homebrew)
     - [Debian Based](#debian-and-derivatives-ubuntu)
     - [Fedora Based](#fedora)
     - [Arch Based](#ARCH-LINUX-AND-ITS-DERIVATIVES)
   - [BASIC GIT CHECKOUT](#BASIC-GIT-CHECKOUT)
   - [CONFIGURE YOUR SHELL](#CONFIGURE-YOUR-SHELL)
 - [Make Sure That Your System Can Build Ruby](#make-sure-that-your-system-can-build-ruby)
 - [Installing Ruby Versions](#INSTALLING-RUBY-VERSIONS)
   - [List Stable Versions](#LIST-STABLE-VERSIONS)
   - [List All Versions](#list-all-versions)
   - [Install a Version](#INSTALL-A-VERSION)
   - [Setting a Ruby Version](#setting-a-ruby-version)
   - [Errors Installing](#errors-or-failures)
  - [Gems](#INSTALLING-RUBY-GEMS)
   - [Gem Home Location](#GEM-HOME-LOCATION)
  - [Uninstalling Ruby Versions](#UNINSTALLING-RUBY-VERSIONS)
  - [Command Reference](#COMMAND-REFERENCE)
  - [Environment Variables](#environment-variables)
  - [How rbenv Hooks Into Your Shell](#HOW-RBENV-HOOKS-INTO-YOUR-SHELL)
  - [Disabling rbenv](#DISABLING)
  - [Uninstalling](#UNINSTALLING)
  - [Developing](#DEVELOPING)
  - [Alternatives](#alternatives)



### HOW IT WORKS
`rbenv` injects itself into your PATH at installation time. Any invocation of ruby, gem, bundler, or other Ruby-related executable will first activate `rbenv`.

`rbenv` first looks to see if the enviroment variable `RBENV_VERSION` is set. If not, then, `rbenv` scans the current project directory for a file named `.ruby-version`. If found, that file determines the version of Ruby that should be used within that directory. Finally, `rbenv` looks up that Ruby version among those installed under `~/.rbenv/versions/`.


#### E.G.
Imagine you have 2 projects. With `rbenv` you can choose the Ruby version for a specific project

	cd /my_project
	rbenv local 3.1.2 # choose Ruby version 3.1.2:

	cd /my_other_project
	rbenv local 3.4.3 # choose Ruby version 3.4.3:

This will create or update the `.ruby-version` file in the _"my_project"_ directory with Ruby version 3.1.2, and create or update the `.ruby-version` file in the _"my_other_project"_ to use Ruby version 3.4.3.

`rbenv` will seamlessly transition from one Ruby version to another when you switch projects.

Almost every aspect of the `rbenv` mechanism is [customizable via plugins][plugins] written in bash.

## [INSTALLATION](#installation)
There are 2 ways to install `rbenv`: via a package manager (this includes _Homebrew_) or via _Basic Git Checkout_

### [HOMEBREW](#homebrew)
On macOS or Linux, we recommend installing `rbenv` with [Homebrew](https://brew.sh).

	brew install rbenv

### [USING A DISTRO PACKAGE MANAGER](#USING-A-DISTRO-PACKAGE-MANAGER)

##### [DEBIAN AND DERIVATIVES (UBUNTU)](debian-and-derivatives-ubuntu)
> **!!!CAUTION!!!** Debian based distros (like Ubuntu) ship a very old (circa 2019) version of `ruby-build` which does not include the latest version of the Ruby language

	sudo apt install rbenv

The **Basic Git Checkout** might be the easiest way of ensuring that you are always installing the latest version of `rbenv`.

##### [ARCH LINUX AND ITS DERIVATIVES](#ARCH-LINUX-AND-ITS-DERIVATIVES)
Archlinux has [an official package](https://archlinux.org/packages/extra/any/rbenv/) which you can install

	sudo pacman -S rbenv

##### [FEDORA](#FEDORA)
Fedora has [an official package](https://packages.fedoraproject.org/pkgs/rbenv/rbenv/) which you can install

	sudo dnf install rbenv

### [BASIC GIT CHECKOUT](#BASIC-GIT-CHECKOUT)
Use [rbenv-installer](https://github.com/rbenv/rbenv-installer#rbenv-installer) for a more automated install

**IF** you do not want to execute scripts downloaded from a web URL
_(or simply prefer a manual approach, follow the steps below)_

 - Clone `rbenv` into ~/.rbenv
   - `git clone https://github.com/rbenv/rbenv.git ~/.rbenv`
 - Set up your shell to load rbenv
   - `~/.rbenv/bin/rbenv init`


### [CONFIGURE YOUR SHELL](#CONFIGURE-YOUR-SHELL)
**SKIP** if you did the _"Basic Git Checkout"_

After you have installed `rbenv` your shell needs to be configured to load `rbenv`

	rbenv init

**Now you are now ready to install some Ruby versions!**

If you are curious, click [here](https://github.com/rbenv/rbenv?tab=readme-ov-file#how-rbenv-hooks-into-your-shell) to see what `init` does

## [MAKE SURE THAT YOUR SYSTEM CAN BUILD RUBY](#MAKE-SURE-THAT-YOUR-SYSTEM-CAN-BUILD-RUBY)
[Click here](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment) to make sure your system has all the necessary tools, libraries and packages to build Ruby.

The command `install` is not part of `rbenv`, but is a plug-in provided by `ruby-build` [ruby-build](https://github.com/rbenv/ruby-build#readme)

## [INSTALLING RUBY VERSIONS](#INSTALLING-RUBY-VERSIONS)
As seen from the example section above, the `rbenv install x.y.z` is how to install a specific version of the Ruby language. But, to get a list of versions available, the following 2 commands are helpful

###### [LIST STABLE VERSIONS](#LIST-STABLE-VERSIONS)
This will list ONLY the **latest** stable versions of Ruby

    rbenv install -l

	# will output
	3.1.7
	3.2.8
	3.3.8
	3.4.3
	jruby-10.0.0.0
	mruby-3.3.0
	picoruby-3.0.0
	truffleruby-24.2.0
	truffleruby+graalvm-24.2.0

	Only latest stable releases for each Ruby implementation are shown.

###### [LIST ALL VERSIONS](list-all-versions)
To list ALL versions of Ruby available for installation

    rbenv install -L or rbenv install --list-all

###### [INSTALL A VERSION](#INSTALL-A-VERSION)

    rbenv install 3.1.2

Alternatively, you can download and compile Ruby manually as a subdirectory of ~/.rbenv/versions. An entry in that directory can also be a symlink to a Ruby version installed elsewhere on the filesystem.

###### [SETTING A RUBY VERSION](#setting-a-ruby-version)
To finish installation, you **MUST** set a Ruby version

	rbenv global 3.1.2   # set the default Ruby version for this machine
	# or:
	rbenv local 3.1.2    # set the Ruby version for this directory

###### [ERRORS OR FAILURES?](ERRORS-OR-FAILURES)
If a `BUILD FAILED` error occurrs, see the [Ruby Build Discussions](https://github.com/rbenv/ruby-build/discussions/categories/build-failures)

If you get a `command not found` error, you can install ruby-build as a plugin

    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

## [INSTALLING RUBY GEMS](#INSTALLING-RUBY-GEMS)
Gems are installed as they normally would be

	gem install bundler     # recommended gem for all projects
	gem <gem name>

> NOTE!!!
>
> You **should not** use sudo to install gems.
>
> Typically, the Ruby versions will be installed under your home directory and thus writeable by your user. If you get the “you don't have write permissions” error when installing gems, it's likely that your "system" Ruby version is still a global default.
>
> Make sure you ran `rbenv init`, then run `rbenv global <version>` or `rbenv local <version>`

##### [GEM HOME LOCATION](#GEM-HOME-LOCATION)
TO check the location where gems are being installed run the command `gem env home`

    rbenv global 3.4.3  # for example, if 3.4.3 is installed
	gem env home        # outputs ~/.rbenv/versions/3.4.3/lib/ruby/gems/3.4.0

## [UNINSTALLING RUBY VERSIONS](#UNINSTALLING-RUBY-VERSIONS)
As time goes on, Ruby versions you install will accumulate in your `~/.rbenv/versions directory`

There are 2 ways to remove a version

    rbenv versions         # list versions installed
	rbenv uninstall 3.4.3  # remove the 3.4.3 version of ruby

Or, manually by getting the location of the version to remove

	rbenv versions        # list of versions installed
    rbenv prefix 3.4.3    # outputs ~/.rbenv/versions/3.4.3
	cd ~/.rbenv/versions  # directory containing all installed Ruby versions
	rm -rf 3.4.3


## [COMMAND REFERENCE](#COMMAND-REFERENCE)
List of commands available to `rbenv`

| command          | description                                                                                                             |
|------------------|:-----------------------------------------------------------------------------------------------------------------------:|
| global           | reports the currently configured global version                                                                         |
| global <version> | Sets the global version of Ruby to be used in all shells by writing the version name to the `~/.rbenv/version` file     |
| local            | Reports the currently configured local version                                                                          |
| local <version>  | Writes the version to the file `.ruby-version` in the current directory. Overrides the global version                   |
| local --unset    | unsets the local version                                                                                                |
| root             | outputs the location where `rbenv` stores versions, shims, and global version                                           |
| rehash           | Installs shims for all Ruby executables known to `rbenv` (`~/.rbenv/versions/*/bin/*`)                                  |
| shell            | Reports the current value of `RBENV_VERSION`                                                                            |
| shell <version>  | Sets the `RBENV_VERSION` environment variable in your shell. Overrides local & global version                           |
| shell --unset    | Unsets the `RBENV_VERSION` environment variable in your shell                                                           |
| version          | Displays the currently active Ruby version, along with information on how it was set.                                   |
| versions         | Lists all Ruby versions known to rbenv, and shows an asterisk next to the currently active version                      |
| whence           | Lists all Ruby versions that contain the specified executable name                                                      |
| which            | Displays the full path to the executable that `rbenv` will invoke when you run the given command                        |


## [Environment Variables](#environment-variables)
You can affect how rbenv operates with the following settings:

| name             | default    |  description |
|------------------|------------|:-----------------------------------------------------------------------------------------------|
|`RBENV_VERSION`   |            | Specifies the Ruby version to be used.<br>Also see [`rbenv shell`](#rbenv-shell)               |
|`RBENV_ROOT`      | `~/.rbenv` | Defines the directory under which Ruby versions and shims reside.<br>Also see `rbenv root`     |
|`RBENV_DEBUG`     |            | Outputs debug information.<br>Also as: `rbenv --debug <subcommand>`                            |
|`RBENV_HOOK_PATH` |(wiki)[hooks] | Colon-separated list of paths searched for rbenv hooks                                |
|`RBENV_DIR`       | `$PWD`     | Directory to start searching for `.ruby-version` files                                         |


## [HOW RBENV HOOKS INTO YOUR SHELL](#HOW-RBENV-HOOKS-INTO-YOUR-SHELL)
`rbenv init` is a helper command to hook `rbenv` into a shell. It has two modes of operation

 - "rbenv init" edits your shell initialization files on disk to add `rbenv` to shell startup. (Prior to rbenv 1.3.0, this mode only printed user instructions to the terminal, but did nothing else)
 - "rbenv init -" outputs a shell script suitable to be eval'd by a shell

 `rbenv init` will add the following to the `~/.bash_profile` or `~/.zprofile` files

	# Added by `rbenv init` on <DATE>
	eval "$(rbenv init - --no-rehash bash)"

You may add those lines manually to your shell configuration if you want to avoid running `rbenv init`.

Here is what eval'd script generated by `rbenv init` does
 - Adds `rbenv` executable to PATH if necessary
 - Prepends ~/.rbenv/shims directory to PATH (basically the only requirement for `rbenv` to function properly)
 - Installs bash shell completion for `rbenv` commands
 - Regenerates `rbenv` shims (if this slows down shell startup `rbenv init - --no-rehash`)
 - Installs the _"sh"_ dispatcher. While optional, this allows `rbenv` to change variables in your current shell, making commands like `rbenv shell` possible

## [DISABLING](#disabling)
If you want or need to disable `rbenv` simply comment or delete the `rbenv init` line from your shell startup configuration (.zprofile or .bash_profile) then restart your shell

## [UNINSTALLING](#UNINSTALLING)

 - `rm -rf "$(rbenv root)"`
 - remove the `rbenv init` line from your shell startup configuration (.zprofile or .bash_profile)

 If `rbenv` was installed via a package manager, follow that package managers steps to remove it

 - Homebrew: `brew uninstall rbenv`
 - Arch: `pacman -Rs rbenv`
 - Fedora: `dnf remove rbenv`
 - Debian: `apt purge rbenv`

## [DEVELOPING](#DEVELOPING)
Tests are executed using [Bats][bats]:

    $ bats test
    $ bats test/<file>.bats

Please feel free to submit pull requests and file bugs on the [issue
tracker](https://github.com/rbenv/rbenv/issues).

## [ALTERNATIVES](#alternatives)
While simple `rbenv` has some downsides. [Comparison of version managers][alternatives]


  [bats]: https://github.com/bats-core/bats-core
  [ruby-build]: https://github.com/rbenv/ruby-build#readme
  [hooks]: https://github.com/rbenv/rbenv/wiki/Authoring-plugins#rbenv-hooks
  [alternatives]: https://github.com/rbenv/rbenv/wiki/Comparison-of-version-managers
  [plugins]: https://github.com/rbenv/rbenv/wiki/Plugins
