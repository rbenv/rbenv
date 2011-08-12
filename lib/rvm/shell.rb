module RVM
  # Provides Generic access to a more ruby-like shell interface.
  # For more details, see AbstractWrapper.
  module Shell

    require 'rvm/shell/utility'
    require 'rvm/shell/abstract_wrapper'
    require 'rvm/shell/single_shot_wrapper'
    # Current unimplemented
    #require 'rvm/shell/persisting_wrapper'
    # File missing
    #require 'rvm/shell/test_wrapper'
    require 'rvm/shell/result'

    # Returns the default shell wrapper class to use
    def self.default_wrapper
      @@default_wrapper ||= SingleShotWrapper
    end

    # Sets the default shell wrapper class to use.
    def self.default_wrapper=(wrapper)
      @@default_wrapper = wrapper
    end

  end
end
