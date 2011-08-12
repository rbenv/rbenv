module RVM
  class Environment

    # Batch define common operations.
    %w(all archives repos sources logs).each do |cleanup_type|
      define_method(:"cleanup_#{cleanup_type}") do
        rvm(:cleanup, cleanup_type).successful?
      end
    end

    # Returns the ruby-like interface defined by CleanupWrapper
    def cleanup
      @cleanup_wrapper ||= CleanupWrapper.new(self)
    end

    # Implements a Ruby-like interface to cleanup, making it nicer to deal with.
    class CleanupWrapper

      def initialize(parent)
        @parent = parent
      end

      # Cleans up archives, repos, sources and logs
      def all
        @parent.cleanup_all
      end
      alias everything all

      # Cleans up everything in the archives folder
      def archives
        @parent.cleanup_archives
      end

      # Cleans up everything in the repos path
      def repos
        @parent.cleanup_repos
      end
      alias repositories repos

      # Cleans up everything in the source folder
      def sources
        @parent.cleanup_sources
      end
      alias src sources

      # Cleans up all of the logs
      def logs
        @parent.cleanup_logs
      end

    end

  end
end
