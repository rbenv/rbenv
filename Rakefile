require "rubygems"
require "hoe"

Hoe.spec "rvm" do

  developer "Wayne E. Seguin", "wayneeseguin@gmail.com"

  # TODO: package the release with the API .gem
  #gemspec.files           = [
  #  "README", "sha1", "LICENCE", "rvm.gemspec",
  #  # TODO: Go through manifest carefully.
  #  # FOR NOW glob
  #  Dir::glob("lib/**/**"),
  #  Dir::glob("releases/rvm-#{RVM::Version::STRING}.tar.gz*")
  #].flatten

  spec_extras[:rdoc_options] = proc do |ary|
    # hoe kinda sucks for this! TODO: submit patch for Hoe#rdoc_options
    ary.push "--inline-source", "--charset=UTF-8"
  end

  spec_extras[:post_install_message] = <<-POST_INSTALL_MESSAGE
#{"*" * 80}

  This gem contains only the Ruby libraries for the RVM Ruby API.

  In order to install RVM please use one of the methods listed in the
  documentation:

    https://rvm.beginrescueend.com/rvm/install/

  such as,

    bash < <(curl -s -B https://rvm.beginrescueend.com/install/rvm)

  followed by placing the sourcing line in your ~/.bash_profile or wherever may
  be appropriate for your setup (example, .zshenv, /etc/profile, ...):

    # Load RVM into a shell session *as a function*
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

  After completing setup please open a new shell to use RVM and be sure to run
  'rvm notes' to gain a list of dependencies to install before installing the
  first Ruby. You can read more details about this process on the above
  mentioned install page as well as the basics page:

    https://rvm.beginrescueend.com/rvm/basics/

  Enjoy!

      ~Wayne

#{"*" * 80}
    POST_INSTALL_MESSAGE
end

task :test do
  exec "bash -l -c \"./test/suite\""
end
