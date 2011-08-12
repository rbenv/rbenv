require 'rvm'

module RVM
  module Version
    # TODO: delete me - this crap is wholly unnecessary. It is only
    # here right now for backwards compatibility... Unsure if that is
    # necessary at all so I'm being conservative.

    STRING = RVM::VERSION
    MAJOR, MINOR, PATCH = STRING.split(/\./)
  end
end
