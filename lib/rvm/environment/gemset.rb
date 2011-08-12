module RVM
  class Environment

    # Loads a gemset into the current environment.
    # If an argument is given, it will load it from
    # file_prefix.gems
    def gemset_import(file_prefix = nil)
      args = [file_prefix].compact
      rvm(:gemset, :import, *args).successful?
    end
    alias gemset_load gemset_import

    # Exports a gemset.
    def gemset_export(gemset_or_file = nil)
      args = [gemset_or_file].compact
      rvm(:gemset, :export, *args).successful?
    end
    alias gemset_dump gemset_export

    def gemset_list
      normalize_array rvm(:gemset, :list).stdout
    end

    # Creates a new gemset with the given name.
    def gemset_create(*names)
      names = names.flatten
      rvm(:gemset, :create, *names).successful?
    end

    # Copies the gems between two different gemsets.
    def gemset_copy(from, to)
      rvm(:gemset, :copy, from, to).successful?
    end

    # Deletes the gemset with a given name.
    def gemset_delete(name)
      run("echo 'yes' | rvm", :gemset, :delete, name.to_s).successful?
    end

    # Removes all gem-related stuff from the current gemset.
    def gemset_empty
      run("echo 'yes' | rvm", :gemset, :empty).successful?
    end

    # Resets the current gemset to a pristine state.
    def gemset_pristine
      rvm(:gemset, :pristine).successful?
    end

    # Updates all gems in the current gemset.
    def gemset_update
      rvm(@environment_name, :gemset, :update).successful?
    end

    # Prunes the gem cache for the current ruby.
    def gemset_prune
      rvm(:gemset, :prune).successful?
    end

    # Initializes gemsets for a given ruby.
    def gemset_initial
      rvm(:gemset, :initial).successful?
    end

    # Enable or disable the rvm gem global cache.
    def gemset_globalcache(enable = true)
      case enable
        when "enabled", :enabled
          run(:__rvm_using_gemset_globalcache).successful?
        when true, "enable", :enable
          rvm(:gemset, :globalcache, :enable).successful?
        when false, "disable", :disable
          rvm(:gemset, :globalcache, :disable).successful?
        else
          false
      end
    end

    # Changes the current environments gemset. If :replace_env is passed
    # and the ruby is compatible, it will attempt to replace the current
    # processes gem home and path with the one requested.
    def gemset_use(gemset, options = {})
      replace_env = options.delete(:replace_env)
      result = rvm(:gemset, :use, gemset, options)
      if result.successful?
        gemset_name = result[:rvm_gemset_name]
        @environment_name = self.class.environment_with_gemset(@environment_name, gemset_name)
        @expanded_name    = nil
        self.class.reset_current!
        use_env_from_result! result if replace_env
        true
      end
    end

    # Like gemset_use, but replaces the env by default.
    def gemset_use!(name, options = {})
      gemset_use name, {:replace_env => true}.merge(options)
    end

    %w(gemdir gempath gemhome home path version name string dir).each do |action|
      define_method(:"gemset_#{action}") do
        normalize rvm(:gemset, action).stdout
      end
    end

    # Returns the Ruby-like wrapper for gemset operations.
    def gemset
      @gemset_wrapper ||= GemsetWrapper.new(self)
    end

    # Wraps the gemset functionality.
    class GemsetWrapper
      extend Forwardable

      def initialize(parent)
        @parent = parent
      end

      # Import a gemset file.
      def import(prefix)
        @parent.gemset_import prefix.to_s.gsub(/\.gems$/, '')
      end
      alias load import

      # Export a given gemset or, if the name ends with .gems, the current gemset.
      def export(path_or_name)
        @parent.gemset_export path_or_name.to_s
      end
      alias dump export
      alias save export

      # Returns a list of all gemsets belonging to the current ruby.
      def list
        @parent.gemset_list
      end
      alias all list

      # Creates gemsets with the given names.
      def create(*names)
        @parent.gemset_create(*names.flatten)
      end

      # Delete a given gemset.
      def delete(name)
        @parent.gemset_delete(name)
      end

      # Empty the current gemset.
      def empty
        @parent.gemset_empty
      end

      # Restores the current gemset to a pristine state.
      def pristine
        @parent.gemset_pristine
      end

      # Updates all gems in the current gemset.
      def update
        @parent.gemset_update
      end

      # Prune the current gemset.
      def prune
        @parent.gemset_prune
      end

      # Use a given gemset in this environment
      def use(name)
        @parent.gemset_use(name)
      end

      # Use the given gemset, replacing the current
      # gem environment if possible.
      def use!(name)
        @parent.gemset_use(name, :replace_env => true)
      end

      # Shortcut to deal with the gemset global cache.
      def globalcache
        @globalcache ||= GlobalCacheHelper.new(@parent)
      end

      # Copy gems from one gemset to another.
      def copy(from, to)
        @parent.gemset_copy(from, to)
      end

      %w(gemdir gempath gemhome home path version name string dir).each do |action|
        define_method(action) do
          @parent.send(:"gemset_#{action}")
        end
      end

      # A Ruby-like wrapper to manipulate the rvm gem global cache.
      class GlobalCacheHelper

        def initialize(parent)
          @parent = parent
        end

        # Enable the globalcache
        def enable!
          @parent.gemset_globalcache :enable
        end

        # Disable the globalcache
        def disable!
          @parent.gemset_globalcache :disable
        end

        # Returns whether or not the globalcache is enabled.
        def enabled?
          @parent.gemset_globalcache :enabled
        end

      end

    end

  end
end
