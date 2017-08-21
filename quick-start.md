---
layout: default
permalink: /quick-start/
---

##### Homebrew

The quickest way to get up and running with rbenv is with [Homebrew](https://brew.sh/).

~~~
$ brew update
$ brew install rbenv
$ rbenv init
~~~

You'll only ever have to run `rbenv init` once.

##### Installing Ruby versions

~~~ sh
# list all available versions:
$ rbenv install -l

# install a Ruby version:
$ rbenv install 2.0.0-p247
~~~

Alternatively to the `install` command, you can download and compile
Ruby manually as a subdirectory of `~/.rbenv/versions/`. An entry in
that directory can also be a symlink to a Ruby version installed
elsewhere on the filesystem. rbenv doesn't care; it will simply treat
any entry in the `versions/` directory as a separate Ruby version.