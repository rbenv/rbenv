require 'yaml'

module RVM
  module Shell
    # Provides the most common functionality expected of a shell wrapper.
    # Namely, implements general utility methods and tools to extract output
    # from a given command but doesn't actually run any commands itself,
    # leaving that up to concrete implementations.
    #
    # == Usage
    #
    # Commands are run inside of a shell (usually bash) and can either be exectuted in
    # two situations (each with wrapper methods available) - silently or verbosely.
    #
    # Silent commands (via run_silently and run_command) do exactly as
    # they say - that can modify the environment etc but anything they print (to stdout
    # or stderr) will be discarded.
    #
    # Verbose commands will run the command and then print the command epilog (which
    # contains the output stastus and the current env in yaml format). This allows us
    # to not only capture all output but to also return the exit status and environment
    # variables in a way that makes persisted shell sessions possible.
    #
    # Under the hood, #run and run_silently are the preferred ways of invoking commands - if
    # passed a single command, they'll run it as is (much like system in ruby) but when
    # given multiple arguments anything after the first will be escaped (e.g. you can
    # hence pass code etc). #run will also parse the results of this epilog into a usable
    # RVM::Shell::Result object.
    #
    # run_command and run_command_silently do the actual hard work for these behind the scenes,
    # running a string as the shell command. Hence, these two commands are what must be
    # implemented in non-abstract wrappers.
    #
    # For an example of the shell wrapper functionality in action, see RVM::Environment
    # which delegates most of the work to a shell wrapper.
    class AbstractWrapper

      # Used the mark the end of a commands output and the start of the rvm env.
      COMMAND_EPILOG_START = "---------------RVM-RESULTS-START---------------"
      # Used to mark the end of the commands epilog.
      COMMAND_EPILOG_END   = "----------------RVM-RESULTS-END----------------"
      # The location of the shell file with the epilog function definition.
      WRAPPER_LOCATION     = File.expand_path('./shell_wrapper.sh', File.dirname(__FILE__))

      # Defines the shell exectuable.
      attr_reader :shell_executable

      # Initializes a new shell wrapper, including setting the
      # default setup block. Implementations must override this method
      # but must ensure that they call super to perform the expected
      # standard setup.
      def initialize(sh = 'bash', &setup_block)
        setup &setup_block
        @shell_executable = sh
      end

      # Defines a setup block to be run when initiating a wrapper session.
      # Usually used for doing things such as sourcing the rvm file. Please note
      # that the wrapper file is automatically source.
      #
      # The setup block should be automatically run by wrapper implementations.
      def setup(&blk)
        @setup_block = blk
      end

      # Runs the gives command (with optional arguments), returning an
      # RVM::Shell::Result object, including stdout / stderr streams.
      # Under the hood, uses run_command to actually process it all.
      def run(command, *arguments)
        expanded_command = build_cli_call(command, arguments)
        status, out, err = run_command(expanded_command)
        Result.new(expanded_command, status, out, err)
      end

      # Wrapper around run_command_silently that correctly escapes arguments.
      # Essentially, #run but using run_command_silently.
      def run_silently(command, *arguments)
        run_command_silently build_cli_call(command, arguments)
      end

      # Given a command, it will execute it in the current wrapper
      # and once done, will return:
      # - the hash from the epilog output.
      # - a string representing stdout.
      # - a string representing stderr.
      def run_command(full_command)
        raise NotImplementedError.new("run_command is only available in concrete implementations")
      end

      # Like run_command, but doesn't care about output.
      def run_command_silently(full_command)
        raise NotImplementedError.new("run_command_silently is only available in concrete implementations")
      end

      # Returns a given environment variables' value.
      def [](var_name)
        run(:true)[var_name]
      end

      protected

      # When called, will use the current environment to source the wrapper scripts
      # as well as invoking the current setup block. as defined on initialization / via #setup.
      def invoke_setup!
        source_command_wrapper
        @setup_block.call(self) if @setup_block
      end

      # Uses run_silently to source the wrapper file.
      def source_command_wrapper
        run_silently :source, WRAPPER_LOCATION
      end

      # Returns a command followed by the call to show the epilog.
      def wrapped_command(command)
        "#{command}; __rvm_show_command_epilog"
      end

      # Wraps a command in a way that it prints no output.
      def silent_command(command)
        "{ #{command}; } >/dev/null 2>&1"
      end

      # Checks whether the given command includes a epilog, marked by
      # epilog start and end lines.
      def command_complete?(c)
        start_index, end_index = c.index(COMMAND_EPILOG_START), c.index(COMMAND_EPILOG_END)
        start_index && end_index && start_index < end_index
      end

      # Takes a raw string from a processes STDIO and returns three things:
      # 1. The actual stdout, minus epilogue.
      # 2. YAML output of the process results.
      # 3. Any left over from the STDIO text.
      def raw_stdout_to_parts(c)
        raise IncompleteCommandError if !command_complete?(c)
        before, after = c.split(COMMAND_EPILOG_START, 2)
        epilog, after = after.split(COMMAND_EPILOG_END, 2)
        return before, YAML.load(epilog.strip), after
      end

      include RVM::Shell::Utility
    end
  end
end
