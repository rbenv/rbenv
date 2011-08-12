module RVM
  class Environment

    # Generates wrappers with the specified prefix, pointing
    # to ruby_string.
    def wrapper(ruby_string, wrapper_prefix, *binaries)
      rvm(:wrapper, ruby_string, wrapper_prefix, *binaries).successful?
    end

    # Generates the default wrappers.
    def default_wrappers(ruby_string, *binaries)
      wrapper ruby_string, '', *binaries
    end

    # If available, return the path to the wrapper for
    # the given executable. Will return ni if the wrapper
    # is unavailable.
    def wrapper_path_for(executable)
      raise NotImplementedError
    end

  end
end
