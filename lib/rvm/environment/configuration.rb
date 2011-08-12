module RVM
  class Environment

    # Define the config accessor, which basically uses config_value_for and
    # the linke to set the env variable.
    def self.define_config_accessor(*args)
      singleton = (class << self; self; end)
      args.each do |arg|
        singleton.send(:define_method, arg)        { RVM::Environment.config_value_for(arg) }
        singleton.send(:define_method, :"#{arg}=") { |v| RVM::Environment.merge_config! arg => v }
      end
    end

    define_config_accessor :rvm_path, :rvm_config_path, :rvm_bin_path

    # Mixin for a set of configs.
    module ConfigMixin

      # Returns the current config for this scope
      def config
        @config ||= {}
      end

      # Merge a set of items into the config.
      def merge_config!(r)
        r.each_pair { |k, v| config[k.to_s] = v }
      end

      # Reset this local config to be empty.
      def clear_config!
        @config = {}
      end
    end

    include ConfigMixin
    extend  ConfigMixin

    # Gets the default option or the current
    # environment variable for a given env var.
    def self.config_value_for(value)
      value = value.to_s
      config[value] || ENV[value]
    end

    # Returns the value for a configuration option (mapping to an
    # environment variable). If check_live is true (which it is
    # by default), it will also check the environment for a value.
    def config_value_for(key, default = nil, check_live = true)
      key = key.to_s
      value = check_live ? self[key.to_s] : nil
      value || config[key] || self.class.config_value_for(key) || default
    end

    # Returns a hash of all of the user defined configuration.
    def defined_config
      self.class.config.merge(self.config)
    end

  end
end
