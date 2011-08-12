# Recipes for using RVM on a server with capistrano.

unless Capistrano::Configuration.respond_to?(:instance)
  abort "rvm/capistrano requires Capistrano >= 2."
end

Capistrano::Configuration.instance(true).load do

  # Taken from the capistrano code.
  def _cset(name, *args, &block)
    unless exists?(name)
      set(name, *args, &block)
    end
  end

  set :default_shell do
    shell = File.join(rvm_bin_path, "rvm-shell")
    ruby = rvm_ruby_string.to_s.strip
    shell = "rvm_path=#{rvm_path} #{shell} '#{ruby}'" unless ruby.empty?
    shell
  end

  # Let users set the type of their rvm install.
  _cset(:rvm_type, :system)

  # Define rvm_path
  # This is used in the default_shell command to pass the required variable to rvm-shell, allowing
  # rvm to boostrap using the proper path.  This is being lost in Capistrano due to the lack of a
  # full environment.
  _cset(:rvm_path) do
    case rvm_type
    when :root, :system
      "/usr/local/rvm"
    when :local, :user, :default
      "$HOME/.rvm/"
    else
      rvm_type.to_s.empty? ?  "$HOME/.rvm" : rvm_type.to_s
    end
  end

  # Let users override the rvm_bin_path
  _cset(:rvm_bin_path) do
    case rvm_type
    when :root, :system
      "/usr/local/rvm/bin"
    when :local, :user, :default
      "$HOME/.rvm/bin"
    else
      rvm_type.to_s.empty? ?  "#{rvm_path}/bin" : rvm_type.to_s
    end
  end

  # Use the default ruby on the server, by default :)
  _cset(:rvm_ruby_string, "default")
end

# E.g, to use ree and rails 3:
#
#   require 'rvm/capistrano'
#   set :rvm_ruby_string, "ree@rails3"
#
