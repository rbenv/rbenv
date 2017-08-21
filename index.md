---
layout: default
---

# Groom your app’s Ruby environment with rbenv.

Use rbenv to pick a Ruby version for your application and guarantee
that your development environment matches production. Put rbenv to work
with [Bundler](http://bundler.io/) for painless Ruby upgrades and
bulletproof deployments.

**Powerful in development.** Specify your app's Ruby version once,
  in a single file. Keep all your teammates on the same page. No
  headaches running apps on different versions of Ruby. Just Works™
  from the command line and with app servers like [Pow](http://pow.cx).
  Override the Ruby version anytime: just set an environment variable.

**Rock-solid in production.** Your application's executables are its
  interface with ops. With rbenv and [Bundler
  binstubs](https://github.com/rbenv/rbenv/wiki/Understanding-binstubs)
  you'll never again need to `cd` in a cron job or Chef recipe to
  ensure you've selected the right runtime. The Ruby version
  dependency lives in one place—your app—so upgrades and rollbacks are
  atomic, even when you switch versions.

**One thing well.** rbenv is concerned solely with switching Ruby
  versions. It's simple and predictable. A rich plugin ecosystem lets
  you tailor it to suit your needs. Compile your own Ruby versions, or
  use the [ruby-build][]
  plugin to automate the process. Specify per-application environment
  variables with [rbenv-vars](https://github.com/rbenv/rbenv-vars).
  See more [plugins on the
  wiki](https://github.com/rbenv/rbenv/wiki/Plugins).

[**Why choose rbenv over
RVM?**](https://github.com/rbenv/rbenv/wiki/Why-rbenv%3F)