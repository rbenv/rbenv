module RVM
  module Shell
    # Represents the output of a shell command.
    # This includes the exit status (and the helpful #successful? method)
    # as well accessors for the command and stdout / stderr.
    class Result

      attr_reader :command, :stdout, :stderr, :raw_status

      # Creates a new result object with the given details.
      def initialize(command, status, stdout, stderr)
        @command     = command.dup.freeze
        @raw_status  = status
        @environment = (@raw_status ? (@raw_status["environment"] || {}) : {})
        @successful  = (exit_status == 0)
        @stdout      = stdout.freeze
        @stderr      = stderr.freeze
      end

      # Returns the hash of the environment.
      def env
        @environment
      end

      # Whether or not the command had a successful exit status.
      def successful?
        @successful
      end

      # Returns a value from the outputs environment.
      def [](key)
        env[key.to_s]
      end

      # Returns the exit status for the program
      def exit_status
        @exit_status ||= (Integer(@raw_status["exit_status"]) rescue 1)
      end

    end
  end
end
