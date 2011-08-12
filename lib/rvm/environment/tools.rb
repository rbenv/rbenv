module RVM
  class Environment

    # Gets the full name for the current env.
    def tools_identifier
      normalize rvm(:tools, :identifier).stdout
    end

    # Gets the identifier after cd'ing to a path, no destructive.
    def tools_path_identifier(path)
      path_identifier = rvm(:tools, "path-identifier", path.to_s)
      if path_identifier.exit_status == 2
        error_message = "The rvmrc located in '#{path}' could not be loaded, likely due to trust mechanisms."
        error_message << " Please run 'rvm rvmrc {trust,untrust} \"#{path}\"' to continue, or set rvm_trust_rvmrcs_flag to 1."
        raise ErrorLoadingRVMRC, error_message
      end
      return normalize(path_identifier.stdout)
    end

    def tools_strings(*rubies)
      rubies = rubies.flatten.join(",").split(",").uniq
      names = {}
      value = rvm(:tools, :strings, *rubies)
      if value.successful?
        parts = value.stdout.split
        rubies.each_with_index do |key, index|
          names[key] = normalize(parts[index])
        end
      end
      names
    end

    # Return the tools wrapper.
    def tools
      @tools_wrapper ||= ToolsWrapper.new(self)
    end

    # Ruby like wrapper for tools
    class ToolsWrapper

      def initialize(parent)
        @parent = parent
      end

      # Returns the current envs expanded identifier
      def identifier
        @parent.tools_identifier
      end

      # Returns the identifier for a path, taking into account
      # things like an rvmrc
      def path_identifier(path)
        @parent.tools_path_identifier(File.expand_path(path))
      end
      alias identifier_for_path path_identifier

      def strings(*rubies)
        @parent.tools_strings(*rubies)
      end

      def expand_string(ruby)
        strings(ruby)[ruby]
      end

    end

  end
end
