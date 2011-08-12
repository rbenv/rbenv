require 'open3'

module RVM
  module Shell
    # Implementation of the abstract wrapper class that opens a new
    # instance of bash when a command is run, only keeping it around
    # for the lifetime of the command. Possibly inefficient but for
    # the moment simplest and hence default implementation.
    class SingleShotWrapper < AbstractWrapper

      attr_accessor :current

      # Runs a given command in the current shell.
      # Defaults the command to true if empty.
      def run_command(command)
        command = "true" if command.to_s.strip.empty?
        with_shell_instance do
          stdin.puts wrapped_command(command)
          stdin.close
          out, err = stdout.read, stderr.read
          out, status, _ = raw_stdout_to_parts(out)
          return status, out, err
        end
      end

      # Runs a command, ensuring no output is collected.
      def run_command_silently(command)
        with_shell_instance do
          stdin.puts silent_command(command)
        end
      end

      protected

      # yields stdio, stderr and stdin for a shell instance.
      # If there isn't a current shell instance, it will create a new one.
      # In said scenario, it will also cleanup once it is done.
      def with_shell_instance(&blk)
        no_current = @current.nil?
        if no_current
          @current = Open3.popen3(self.shell_executable)
          invoke_setup!
        end
        yield
      ensure
        @current = nil if no_current
      end

      # Direct access to each of the named descriptors
      def stdin;  @current[0]; end
      def stdout; @current[1]; end
      def stderr; @current[2]; end

    end
  end
end
