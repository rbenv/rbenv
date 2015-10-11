if [ ! -x "$RBENV_COMMAND_PATH" ]; then
  gemdir=""
  case "$RBENV_VERSION" in
  1.8* ) gemdir="ruby/1.8" ;;
  1.9* ) gemdir="ruby/1.9.1" ;;
  2.* ) gemdir="ruby/${RBENV_VERSION:0:3}.0" ;;
  jruby-1.* ) gemdir="jruby/1.9" ;;
  jruby-9000* ) gemdir="jruby/2.1" ;;
  rbx-2.* ) gemdir="rbx/2.1" ;;
  esac

  if [ -n "$gemdir" ]; then
    RBENV_COMMAND_PATH="${HOME}/.gem/${gemdir}/bin/${RBENV_COMMAND}"
  fi
fi
