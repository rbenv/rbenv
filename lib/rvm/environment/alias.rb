module RVM
  class Environment

    # Returns a hash of aliases.
    def alias_list
      lines = normalize_array(rvm(:alias, :list).stdout)
      lines.inject({}) do |acc, current|
        alias_name, ruby_string = current.to_s.split(" => ")
        unless alias_name.empty? || ruby_string.empty?
          acc[alias_name] = ruby_string
        end
        acc
      end
    end

    # Shows the full ruby string that a given alias points to.
    def alias_show(name)
      normalize rvm(:alias, :show, name.to_s).stdout
    end

    # Deletes an alias and returns the exit status.
    def alias_delete(name)
      rvm(:alias, :delete, name.to_s).successful?
    end

    # Creates an alias with the given name.
    def alias_create(name, ruby_string)
      rvm(:alias, :create, name.to_s, ruby_string.to_s).successful?
    end

    # Returns an aliases proxy which can be used in a more Ruby-like manner.
    def aliases
      @aliases ||= AliasWrapper.new(self)
    end

    # Provides a Ruby-like wrapper to the alias functionality.
    class AliasWrapper

      def initialize(parent)
        @parent = parent
      end

      # Shows the value of a given alias.
      def show(name)
        @parent.alias_show name
      end
      alias [] show

      # Deletes the given alias.
      def delete(name)
        @parent.alias_delete name
      end

      # Creates an alias with a given name and ruby string.
      def create(name, ruby_string)
        @parent.alias_create name, ruby_string
      end
      alias []= create

      # Returns a hash of all aliases.
      def list
        @parent.alias_list
      end
      alias all list

    end

  end
end
