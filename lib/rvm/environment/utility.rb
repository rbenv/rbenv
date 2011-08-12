module RVM
  class Environment

    PREFIX_OPTIONS = [:trace, :json, :yaml]

    def self.default_rvm_path
      value = `bash '#{File.expand_path('../shell/calculate_rvm_path.sh', File.dirname(__FILE__))}'`.strip
      $?.success? && !value.empty? ? File.expand_path(value) : nil
    end

    # Returns the environment identifier for the current environment,
    # as determined from the GEM_HOME.
    def self.current_environment_id
      @current_environment_id ||= begin
        gem_home = ENV['GEM_HOME'].to_s.strip
        if !gem_home.empty? && gem_home =~ /rvm\/gems\//
          File.basename(gem_home)
        else
          matching_path = $:.select { |item| item =~ /rvm\/rubies/ }.first
          matching_path.to_s.gsub(/^.*rvm\/rubies\//, '').split('/')[0] || "system"
        end
      end
    end

    # Returns the ruby string that represents the current environment.
    def self.current_ruby_string
      identifier_to_ruby_string(current_environment_id)
    end

    # Converts a ruby identifier (string + gemset) to just the ruby string.
    def self.identifier_to_ruby_string(identifier)
      identifier.gsub(/@.*$/, '')
    end

    # Returns the currentl environment.
    # Note that when the ruby is changed, this is reset - Also,
    # if the gemset is changed it will also be reset.
    def self.current
      @current_environment ||= Environment.new(current_environment_id)
    end

    # Sets the current environment back to the currently running ruby
    # or the system env (if it can't be determined from GEM_HOME).
    def self.reset_current!
      @current_environment = nil
    end

    # Lets you build a command up, without needing to see the output.
    # As an example,
    #
    #  rvm :use, "ree@rails3", :install => true
    #
    # Will call the following:
    #
    #  rvm use ree@rails3 --install
    #
    def rvm(*args)
      options = extract_options!(args)
      silent = options.delete(:silent)
      rearrange_options!(args, options)
      args += hash_to_options(options)
      args.map! { |a| a.to_s }

      if silent
        run_silently('rvm', *args)
      else
        run('rvm', *args)
      end
    end

    # Run commands inside the given directory.
    def chdir(dir)
      run_silently :pushd, dir.to_s
      result = Dir.chdir(dir) { yield }
      run_silently :popd
      result
    end

    protected

    # Moves certain options (e.g. yaml, json etc) to the front
    # of the arguments list, making stuff like sets work.
    def rearrange_options!(args, options)
      prefix_options = {}
      (PREFIX_OPTIONS + PREFIX_OPTIONS.map { |o| o.to_s }).each do |k|
        if options.has_key?(k)
          value = options.delete(k)
          prefix_options[k.to_sym] = value
        end
      end
      hash_to_options(prefix_options).reverse.each { |o| args.unshift(o) }
    end

    def ruby_string(result)
      if result && result[:rvm_ruby_string]
        result[:rvm_ruby_string]
      else
        self.class.identifier_to_ruby_string(expanded_name)
      end
    end

    # Checks whether the given environment is compatible with the current
    # ruby interpeter.
    def compatible_with_current?(result)
      ruby_string(result) == self.class.current_ruby_string
    end

    # Given an environment identifier, it will add the the given
    # gemset to the end to form a qualified identifier name.
    def self.environment_with_gemset(environment, gemset)
      environment_name, gemset_name = environment.split("@", 2)
      environment_name = "default"     if environment_name.to_s.empty?
      environment_name << "@#{gemset}" unless gemset.to_s.empty?
      environment_name
    end

    # Returns a value, or nil if it is blank.
    def normalize(value)
      value = value.to_s.strip
      value.empty? ? nil : value
    end

    # Normalizes an array, removing blank lines.
    def normalize_array(value)
      value.split("\n").map { |line| line.strip }.reject { |line| line.empty? }
    end

    # Extract options from a hash.
    def extract_options!(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end

    # Converts a hash of options to an array of command line argumets.
    # If the value is false, it wont be added but if it is true only the
    # key will be added. Lastly, when the value is neither true or false,
    # to_s will becalled on it and it shall be added to the array.
    def hash_to_options(options)
      result = []
      options.each_pair do |key, value|
        real_key = "--#{key.to_s.gsub("_", "-")}"
        if value == true
          result << real_key
        elsif value != false
          result << real_key
          result << value.to_s
        end
      end
      result
    end

    # Recursively normalize options.
    def normalize_option_value(value)
      case value
      when Array
        value.map { |option| normalize_option_value(option) }.join(",")
      else
        value.to_s
      end
    end

    def use_env_from_result!(result)
      if compatible_with_current?(result)
        ENV['GEM_HOME']    = result[:GEM_HOME]
        ENV['GEM_PATH']    = result[:GEM_PATH]
        Gem.clear_paths if defined?(Gem)
      else
        raise IncompatibleRubyError.new(result, "The given ruby environment requires #{ruby_string(result)} (versus #{self.class.current_ruby_string})")
      end
    end

  end
end
