= rvm

* http://github.com/wayneeseguin/rvm

== DESCRIPTION:

RVM is the Ruby enVironment Manager (rvm).
It manages Ruby application environments and switching between them.

== Usage

  rvm [Flags] [Options] Action [Implementation[,Implementation[,...]]

== Flags

  --default     - with 'rvm use X', sets the default ruby for new shells to X.
  --debug       - Toggle debug mode on for very verbose output.
  --trace       - Toggle trace mode on to see EVERYTHING rvm is doing.
  --force       - Force install, removes old install & source before install.
  --summary     - Used with rubydo to print out a summary of the commands run.
  --latest      - with gemset --dump skips version strings for latest gem.
  --gems        - with uninstall/remove removes gems with the interpreter.
  --docs        - with install, attempt to generate ri after installation.
  --reconfigure - Force ./configure on install even if Makefile already exists.

== Options

  -v|--version    - Emit rvm version loaded for current shell
  -l|--level      - patch level to use with rvm use / install
     --prefix     - path for all rvm files (~/.rvm/), with trailing slash!
     --bin        - path for binaries to be placed (~/.rvm/bin/)
  -S              - Specify a script file to attempt to load and run (rubydo)
  -e              - Execute code from the command line.
  --gems          - Used to set the 'gems_flag', use with 'remove' to remove gems
  --archive       - Used to set the 'archive_flag', use with 'remove' to remove archive
  --patch         - With MRI Rubies you may specify one or more full paths to patches
                    for multiple, specify comma separated:
                    --patch /.../.../a.patch[%prefix],/.../.../.../b.patch
                    'prefix' is an optional argument, which will be bypassed
                    to the '-p' argument of the 'patch' command. It is separated
                    from patch file name with '%' symbol.
  -C|--configure  - custom configure options. If you need to pass several configure
                    options then append them comma separated: -C --...,--...,--...
  --nice          - process niceness (for slow computers, default 0)
  --ree-options   - Options passed directly to ree's './installer' on the command line.
  --with-rubies   - Specifies a string for rvm to attempt to expand for set operations.

== Action

  (Note that for most actions, 'rvm help action-name' may provide more information.)

  * usage    - show this usage information
  version    - show the rvm version installed in rvm_path
  use        - setup current shell to use a specific ruby version
  reload     - reload rvm source itself (useful after changing rvm source)
  implode    - (seppuku) removes the rvm installation completely.
               This means everything in $rvm_path (~/.rvm).
               This does not touch your profiles, which is why
               there is an if around the sourcing scripts/rvm.
  get        - {head,latest} upgrades rvm to latest head or release version.
               (If you experience bugs try this first with head version, then
                ask for help in #rvm on irc.freenode.net and hang around)
  reset      - remove current and stored default & system settings.
               (If you experience odd behavior try this second)
  info       - show the *current* environment information for current ruby
  current    - print the *current* ruby version and the name of any gemset being used.
  debug      - show info plus additional information for common issues

  install    - install one or many ruby versions
               See also: http://rvm.beginrescueend.com/rubies/installing/
  uninstall  - uninstall one or many ruby versions, leaves their sources
  remove     - uninstall one or many ruby versions and remove their sources

  migrate    - Lets you migrate all gemsets from one ruby to another.
  upgrade    - Lets you upgrade from one version of a ruby to another, including
               migrating your gemsets semi-automatically.

  wrapper    - generates a set of wrapper executables for a given ruby with the
               specified ruby and gemset combination. Used under the hood for
               passenger support and the like.

  cleanup    - Lets you remove stale source folders / archives and other miscellaneous
               data associated with rvm.
  repair     - Lets you repair parts of your environment e.g. wrappers, env files and
               and similar files (e.g. general maintenance).
  snapshot   - Lets your backup / restore an rvm installation in a lightweight manner.

  disk-usage - Tells you how much disk space rvm install is using.
  tools      - Provides general information about the ruby environment,
               primarily useful when scripting rvm.
  docs       - Tools to make installing ri and rdoc documentation easier.
  rvmrc      - Tools related to managing rvmrc trust and loading.

  exec       - runs an arbitrary command as a set operation.
  ruby       - runs a named ruby file against specified and/or all rubies
  gem        - runs a gem command using selected ruby's 'gem'
  rake       - runs a rake task against specified and/or all rubies
  tests      - runs 'rake test' across selected ruby versions
  specs      - runs 'rake spec' across selected ruby versions
  monitor    - Monitor cwd for testing, run `rake {spec,test}` on changes.

  gemset     - gemsets: http://rvm.beginrescueend.com/gemsets/

  rubygems   - Switches the installed version of rubygems for the current ruby.

  gemdir     - display the path to the current gem directory (GEM_HOME).
  srcdir     - display the path to rvm source directory (may be yanked)

  fetch      - Performs an archive / src fetch only of the selected ruby.
  list       - show currently installed rubies, interactive output.
               http://rvm.beginrescueend.com/rubies/list/
  pkg        - Install a dependency package {readline,iconv,zlib,openssl}
               http://rvm.beginrescueend.com/packages/
  notes      - Display notes, with operating system specifics.

  export     - Temporarily set an environment variable in the current shell.
  unexport   - Undo changes made to the environment by 'rvm export'.

== Implementation

  * ruby    - MRI/YARV Ruby (The Gold Standard) {1.8.6,1.8.7,1.9.1,1.9.2...}
  jruby     - JRuby, Ruby interpreter on the Java Virtual Machine.
  rbx       - Rubinius
  ree       - Ruby Enterprise Edition, MRI Ruby with several custom
              patches for performance, stability, and memory.
  macruby   - MacRuby, insanely fast, can make real apps (Mac OS X Only).
  maglev    - GemStone Ruby, awesome persistent ruby object store.
  ironruby  - IronRuby, NOT supported yet. Looking for volunteers to help.
  system    - use the system ruby (eg. pre-rvm state)
  default   - use rvm set default ruby and system if it hasn't been set.
              http://rvm.beginrescueend.com/rubies/default/

== Resources:

  http://rvm.beginrescueend.com/
  https://www.pivotaltracker.com/projects/26822

== Contributions:

  Any and all contributions offered in any form, past present or future, to the
  RVM project are understood to be in complete agreement and acceptance with the
  Apache Licence v2.0.

== INSTALL:

See http://rvm.beginrescueend.com/rvm/install/

or just use:

    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)

== LICENSE:

Copyright (c) 2009-2011 Wayne E. Seguin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
