require 'forwardable'

module RVM
  # Implements the actual wrapper around the api. For more information
  # about this design, see the RVM module.
  class Environment
    extend Forwardable

    %w(configuration utility alias list gemset rubies cleanup sets env tools info wrapper).each do |key|
      require File.join("rvm", "environment", key)
    end

    # The default config has rvm_silence_logging so that log doesn't print anything to stdout.
    merge_config! :rvm_silence_logging => 1,
                  :rvm_promptless      => 1,
                  :rvm_ruby_api        => 1

    attr_reader :environment_name, :shell_wrapper

    # Creates a new environment with the given name and optionally
    # a set of extra environment variables to be set on load.
    def initialize(environment_name = "default", options = {})
      merge_config! options
      @environment_name = environment_name
      @shell_wrapper = Shell.default_wrapper.new
      @shell_wrapper.setup do |s|
        source_rvm_environment
        use_rvm_environment
      end
    end

    def inspect
      "#<#{self.class.name} environment_name=#{@environment_name.inspect}>"
    end

    # Returns the expanded name, using the same method as used by the rvm command line.
    #
    # Suppose that you are in the 1.9.2 patchlevel Environment.
    #
    # env.expanded_name # => "ruby-1.9.2-p0"
    #
    def expanded_name
      @expanded_name ||= tools_identifier.to_s
    end

    # Actually define methods to interact with the shell wrapper.
    def_delegators :@shell_wrapper, :run, :run_silently, :run_command_without_output,
                   :run_command, :[], :escape_argument

    protected

    # Automatically load rvm config from the multiple sources.
    def source_rvm_environment
      rvm_path = config_value_for(:rvm_path, self.class.default_rvm_path, false)
      actual_config = defined_config.merge('rvm_path' => rvm_path)
      config = []
      actual_config.each_pair do |k, v|
        config << "#{k}=#{escape_argument(v.to_s)}"
      end
      run_silently "export #{config.join(" ")}"
      run_silently :source, File.join(rvm_path, "scripts", "rvm")
    end

    def use_rvm_environment
      rvm :use, @environment_name, :silent => true
    end

  end
end
