# == Ruby Version Manager - Ruby API
#
# Provides a wrapper around the command line api implemented as part of the api.
# If you're not familiar with rvm, please read https://rvm.beginrescueend.com/
# first.
#
# == Usage
#
# When using the rvm ruby api, you gain access to most of the commands, including the set
# functionality. As a side node, the RVM module provides access to most of the api
# both via direct api wrappers (of the form <tt><tool>_<action></tt> - e.g. +alias_create+,
# +gemset_use+ and +wrapper+).
#
# == The Environment Model
#
# The RVM ruby api is implemented using an environment model. Each environment maps directly
# to some ruby string interpretable by rvm (e.g. +ree+, +ruby-1.8.7-p174+, +system+, +rbx@rails+
# and so on) and is considered a sandboxed environment (for commands like use etc) in which you
# can deal with rvm. it's worth noting that a single environment can have multiple environment
# instances and for the most part creating of these instances is best handled by the RVM.environment
# and RVM.environments methods.
#
# Each Environment (and instance of RVM::Environment) provides access to the rvm ruby api (in some
# cases, the api may not directly be related to the current ruby - but for simplicity / consistency
# purposes, they are still implemented as methods of RVM::Environment).
#
# When you perform an action with side effects (e.g. RVM::Environment#gemset_use or RVM::Environment#use)
# this will mutate the ruby string of the given environment (hence, an environment is considered mutable).
#
# Lastly, for the actual command line work, RVM::Environment works with an instance of RVM::Shell::AbstractWrapper.
# This performs logic (such as correctly escaping strings, calling the environment and such) in a way that
# is both reusable and simplified.
#
# By default, method_missing is used on the RVM module to proxy method calls to RVM.current (itself
# calling RVM::Environment.current), meaning things like RVM.gemset_name, RVM.alias_create and the like
# work. This is considered the 'global' instance and should be avoided unless needed directly.
#
# RVM::Environment.current will first attempt to use the current ruby string (determined by
# +ENV['GEM_HOME']+ but will fall back to using the rubies load path if that isn't available).
#
# In many cases, (e.g. +alias+, +list+ and the like) there is a more ruby-like wrapper class,
# typically available via <tt>RVM::Environment#<action></tt>.
#
# == Side Notes
#
# In the cases this api differs, see the RVM::Environment class for more information.
#
# You can check the name of a given environment in two ways - RVM::Environment#environment_name
# for the short version / the version set by RVM::Environment#use, RVM::Environment#gemset_use
# or RVM.environment. If you wish to get the full, expanded string (which has things such as
# the actual version of the selected ruby), you instead with to use RVM::Environment#expanded_name.
#
# Lastly, If you do need to pass environment variables to a specific environment, please use
# RVM::Environment.new, versus RVM.environment
#
module RVM
  VERSION = "1.6.32"

  require "rvm/errors"

  require "rvm/shell"
  require "rvm/environment"
  require "rvm/version"

  class << self

    # Returns the current global environment.
    def current
      Environment.current
    end

    # Reset the current global environment to the default / what it was
    # when the process first started.
    def reset_current!
      Environment.reset_current!
    end

    # Returns an array of multiple environments. If given
    # a block, will yield each time with the given environment.
    #
    #   RVM.environments("ree@rails3,rbx@rails3") do |env|
    #     puts "Full environment: #{env.expanded_name}"
    #   end
    #   # => "ree-1.8.7@rails3"
    #   # => "rbx-1.1.0@rails3" # Suppose that you are installed rbx 1.1.0
    #
    # Alternatively, you can use the more ruby-like fashion:
    #
    #   RVM.environments("ree@rails3", "rbx@rails3") do |env|
    #     puts "Full environment: #{env.expanded_name}"
    #   end
    #
    def environments(*names, &blk)
      # Normalize the names before using them on for the environment.
      names.flatten.join(",").split(",").uniq.map do |n|
        environment(n, &blk)
      end
    end

    # Returns the environment with the given name.
    # If passed a block, will yield with that as the single argument.
    #
    #   RVM.environment("ree@rails3") do |env|
    #     puts "Gemset is #{env.gemset.name}"
    #   end
    #
    def environment(name)
      # TODO: Maintain an Environment cache.
      # The cache needs to track changes via use etc though.
      env = Environment.new(name)
      yield env if block_given?
      env
    end

    # Merges items into the default config, essentially
    # setting environment variables passed to child processes:
    #
    #   RVM.merge_config!({
    #     :some_shell_variable => "me",
    #   })
    #
    def merge_config!(config = {})
      Environment.merge_config!(config)
    end

    # Returns the current 'best guess' value for rvm_path.
    def path
      Environment.rvm_path
    end

    #  Shortcut to set rvm_path. Will set it on all new instances
    #  but wont affect currently running environments.
    def path=(value)
      Environment.rvm_path = value
    end

    private

    def cache_method_call(name)
      class_eval <<-END, __FILE__, __LINE__
        def #{name}(*args, &blk)
          current.__send__(:#{name}, *args, &blk)
        end
      END
    end

    # Proxies methods to the current environment, creating a
    # method before dispatching to speed up future calls.
    def method_missing(name, *args, &blk)
      if current.respond_to?(name)
        cache_method_call name
        current.__send__ name, *args, &blk
      else
        super
      end
    end

  end

end
