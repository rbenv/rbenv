module RVM

  # Generic error in RVM
  class Error < StandardError; end

  # Generic error with the shell command output attached.
  # The RVM::Shell::Result instance is available via +#result+.
  class ErrorWithResult < Error
    attr_reader :result

    def initialize(result, message = nil)
      @result = result
      super message
    end

  end

  # Something occured processing the command and rvm couldn't parse the results.
  class IncompleteCommandError < Error; end

  # The given action can't replace the env for the current process.
  # Typically raised by RVM::Environment#gemset_use when the gemset
  # is for another, incompatible ruby interpreter.
  #
  # Provides access to the output of the shell command via +#result+.
  class IncompatibleRubyError < ErrorWithResult; end
  
  # Called when tools.path_identifier is called on a dir with an untrusted rvmrc.
  class ErrorLoadingRVMRC < Error; end

end
