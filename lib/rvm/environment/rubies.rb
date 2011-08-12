module RVM
  class Environment

    # Installs the given ruby
    def install(rubies, opts = {})
      rvm(:install, normalize_ruby_string(rubies), opts).successful?
    end

    # Uninstalls a ruby (remove but keeps src etc)
    def uninstall(rubies, opts = {})
      rvm(:uninstall, normalize_ruby_string(rubies), opts).successful?
    end

    # Removes a given ruby from being managed by rvm.
    def remove(rubies, opts = {})
      rvm(:remove, normalize_ruby_string(rubies), opts).successful?
    end

    # Changes the ruby string for the current environment.
    #
    # env.use '1.9.2' # => nil
    # env.use 'ree' # => nil
    #
    def use(ruby_string, opts = {})
      ruby_string = ruby_string.to_s
      result = rvm(:use, ruby_string)
      if result.successful?
        @environment_name = ruby_string
        @expanded_name    = nil
        use_env_from_result! result if opts[:replace_env]
      end
    end

    # Like use but with :replace_env defaulting to true.
    def use!(ruby_string, opts = {})
      use ruby_string, opts.merge(:replace_env => true)
    end

    # Will get the ruby from the given path. If there
    # is a compatible ruby found, it will then attempt
    # to use the associated gemset.
    # e.g. RVM::Environment.current.use_from_path! Dir.pwd
    def use_from_path!(path)
     use! tools.path_identifier(path)
    end

    protected

    def normalize_ruby_string(rubies)
      Array(rubies).join(",")
    end

  end
end
