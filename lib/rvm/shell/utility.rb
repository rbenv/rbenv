module RVM
  module Shell
    module Utility

      public

      # Takes an array / number of arguments and converts
      # them to a string useable for passing into a shell call.
      def escape_arguments(*args)
        return '' if args.nil?
        args.flatten.map { |a| escape_argument(a.to_s) }.join(" ")
      end

      # Given a string, converts to the escaped format. This ensures
      # that things such as variables aren't evaluated into strings
      # and everything else is setup as expected.
      def escape_argument(s)
        return "''" if s.empty?
        s.scan(/('+|[^']+)/).map do |section|
          section = section.first
          if section[0] == ?'
            "\\'" * section.length
          else
            "'#{section}'"
          end
        end.join
      end

      # From a command, will build up a runnable command. If args isn't provided,
      # it will escape arguments.
      def build_cli_call(command, args = nil)
        "#{command} #{escape_arguments(args)}".strip
      end

    end
  end
end
