module RVM
  class Environment

    # Passed either something containing ruby code or
    # a path to a ruby file, will attempt to exectute
    # it in the current environment.
    def ruby(runnable, options = {})
      if runnable.respond_to?(:path)
        # Call the path
        ruby_run runnable.path, options
      elsif runnable.respond_to?(:to_str)
        runnable = runnable.to_str
        File.exist?(runnable) ? ruby_run(runnable, options) : ruby_eval(runnable, options)
      elsif runnable.respond_to?(:read)
        ruby_run runnable.read
      end
    end

    # Eval the given code within ruby.
    def ruby_eval(code, options = {})
      perform_set_operation :ruby, "-e", code.to_s, options
    end

    # Run the given path as a ruby script.
    def ruby_run(path, options = {})
      perform_set_operation :ruby, path.to_s, options
    end

    # Execute rake (optionally taking the path to a rake file),
    # then change back.
    def rake(file = nil, options = {})
      if file.nil?
        perform_set_operation :rake, options
      else
        file = File.expand_path(file)
        chdir(File.dirname(file)) do
          perform_set_operation(:rake, options.merge(:rakefile => file))
        end
      end
    end

    # Use the rvm test runner for unit tests.
    def tests(options = {})
      perform_set_operation :tests, options
    end

    # Use the rvm spec runner for specs.
    def specs(options = {})
      perform_set_operation :specs, options
    end

    # Like Kernel.system, but evaluates it within the environment.
    # Also note that it doesn't support redirection etc.
    def system(command, *args)
      identifier = extract_identifier!(args)
      args = [identifier, :exec, command, *args].compact
      rvm(*args).successful?
    end

    # Executes a command, replacing the current shell.
    # exec is a bit of an odd ball compared to the others, since
    # it has to use the Kernel.exec builtin.
    def exec(command, *args)
      command = @shell_wrapper.build_cli_call(:exec, [command] + args)
      Kernel.exec "bash", "-c", "source '#{env_path}'; #{command}"
    end

    protected

    # Converts the given identifier to a rvm-friendly form.
    # Unlike using sets directly, a nil identifier is set
    # to mean the current ruby (not all). :all or "all" will
    # instead return the a blank identifier / run it against
    # all rubies.
    def normalize_set_identifier(identifier)
      case identifier
      when nil, ""
        @environment_name
      when :all, "all"
        nil
      when Array
        identifier.map { |i| normalize_set_identifier(i) }.uniq.join(",")
      else
        identifier.to_s
      end
    end

    # From an options hash, extract the environment identifier.
    def extract_environment!(options)
      values = []
      [:environment, :env, :rubies, :ruby].each do |k|
        values << options.delete(k)
      end
      values.compact.first
    end

    # Shorthand to extra an identifier from args.
    # Since we
    def extract_identifier!(args)
      options = extract_options!(args)
      identifier = normalize_set_identifier(extract_environment!(options))
      args << options
      identifier
    end

    # Performs a set operation. If the :env or :environment option is given,
    # it will return a yaml summary (instead of the stdout / stderr etc via
    # a Result object.
    def perform_set_operation(*args)
      options     = extract_options!(args)
      environment = extract_environment!(options)
      identifier  = normalize_set_identifier(environment)
      # Uses yaml when we have multiple identifiers.
      uses_yaml   = !environment.nil?
      options.merge!(:yaml => true) if uses_yaml
      args.unshift(identifier) unless identifier.nil?
      args << options
      result = rvm(*args)
      uses_yaml ? YAML.load(result.stdout) : result
    end

  end
end
