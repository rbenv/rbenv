# Prints out the rvm command (minus rvm install) to install this ruby.

RUBY_NAME = File.basename(ENV['MY_RUBY_HOME'])
RVM_HOME  = ENV['rvm_path']

def ruby?(*names)
  names.map { |n| n.to_s }.include?(RUBY_NAME.split("-").first)
end

def quote(value)
  value = value.to_s.strip
  value.empty? ? "" : "'#{value.gsub("'", "'\'\'")}'"
end

def normalize_argument(arg)
  real_value, arg_value = arg.split("=", 2)
  if !arg_value.nil?
    real_value << "=#{quote(arg_value)}"
  end
  real_value.gsub("'#{RVM_HOME}", "'\"$rvm_path\"'")
end

def arguments_for_install
  if ruby?(:ruby, :ree, :goruby)
    begin
      require 'rbconfig'
      require 'shellwords'
      # Get the full arguments
      config_args = Shellwords.shellwords(Config::CONFIG['configure_args'].to_s.strip)
      real_arguments = []
      config_args.each do |arg|
        if ruby?(:ree) && arg == "--enable-mbari-api"
          next
        elsif arg =~ /^--prefix/
          next
        elsif arg =~ /^[^\-]/
          next
        else
          real_arguments << normalize_argument(arg)
        end
      end
      config_args = real_arguments.join(",")
      return "-C #{quote(config_args)}" unless config_args.strip.empty?
    rescue LoadError
    end
  end
  return ""
end

# Finally, print the string to install it.
puts "rvm install #{RUBY_NAME} #{arguments_for_install.gsub(/''+/, "'")}".strip
