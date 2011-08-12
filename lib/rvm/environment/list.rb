module RVM
  class Environment

    # Returns a raw array list of ruby + gemset combinations.
    #
    # env.list_gemsets # => ['ruby-1.9.2-p0@my_gemset', 'jruby@my_gemset', ...]
    #
    def list_gemsets
      normalize_listing_output rvm(:list, :gemsets, :strings).stdout
    end

    # Returns a raw array list of installed ruby strings, including aliases.
    #
    # env.list_strings # => ["ruby-1.9.2-p0", "jruby-1.5.3"]
    #
    def list_strings
      normalize_listing_output rvm(:list, :strings).stdout.tr(' ', "\n")
    end

    # Lists the default ruby (minus gemset)
    # Suppose that Ruby 1.9.2 patchlevel 0, is the default:
    # 
    # env.list_default # => "ruby-1.9.2-p0"
    #
    def list_default
      normalize rvm(:list, :default, :string).stdout
    end

    # Lists all known ruby strings (raw, filtered output)
    #
    def list_known
      normalize_listing_output rvm(:list, :known).stdout
    end

    # Lists all known ruby strings
    #
    def list_known_strings
      normalize_listing_output rvm(:list, :known_strings).stdout
    end

    # Lists all known svn tags.
    #
    def list_ruby_svn_tags
      normalize_listing_output rvm(:list, :ruby_svn_tags).stdout
    end

    # Returns an interface to a more Ruby-like interface for list.
    #
    def list
      @list_helper ||= ListWrapper.new(self)
    end

    # Provides a ruby-like interface to make listing rubies easier.
    #
    class ListWrapper

      def initialize(parent)
        @parent = parent
      end

      # Returns an array of ruby + gemset combinations.
      def gemsets
        @parent.list_gemsets
      end

      # Returns an array of installed rubies.
      def rubies
        @parent.list_strings
      end
      alias installed rubies
      alias strings rubies

      # Shows the current default. If :gemset is passed in and is
      # true, it will include the gemset in the output.
      def default(options = {})
        options[:gemset] ? @parent.show_alias(:default) : @parent.list_default
      end

      # A raw list of known rubies.
      def raw_known
        @parent.list_known
      end

      def known_strings
        @parent.list_known_strings
      end

      # A list of known ruby strings, minus svn tags.
      def expanded_known
        raw_known.map do |raw|
          expand_variants(raw)
        end.flatten.uniq.sort
      end

      # Raw list of svn tagged version
      def raw_ruby_svn_tags
        @parent.list_ruby_svn_tags
      end

      # Normalized list of ruby svn tags.
      def ruby_svn_tags
        raw_ruby_svn_tags.map { |t| expand_variants(t) }.flatten.uniq.sort
      end
      alias from_svn ruby_svn_tags

      # Most installable ruby strings.
      def installable
        (expanded_known + ruby_svn_tags).uniq.sort
      end

      protected

      # Expands strings to include optional parts (surrounded in brackets),
      # given a useable string.
      def expand_variants(s)
        if s =~ /(\([^\)]+\))/
          part = $1
          expand_variants(s.sub(part, "")) + expand_variants(s.sub(part, part[1..-2]))
        else
          [s]
        end
      end

    end

    protected

    # Takes a list of rubies / items, 1 per line and strips comments and blank lines.
    def normalize_listing_output(results)
      lines = []
      results.each_line do |line|
        line = line.gsub(/#.*/, '').strip
        lines << line unless line.empty?
      end
      lines.sort
    end

  end
end
