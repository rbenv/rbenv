hook = lambda do |installer|
  begin
    # Ignore gems that aren't installed in locations that rbenv searches for binstubs
    if installer.spec.executables.any? &&
        [Gem.default_bindir, Gem.bindir(Gem.user_dir)].include?(installer.bin_dir)
      `rbenv rehash`
    end
  rescue
    warn "rbenv: error in gem-rehash (#{$!})"
  end
end

if defined?(Bundler::Installer) && Bundler::Installer.respond_to?(:install)
  warn "bundler hook"
  Bundler::Installer.class_eval do
    class << self
      alias install_without_rbenv_rehash install
      def install(root, definition, options = {})
        result = install_without_rbenv_rehash(root, definition, options)
        begin
          warn "%p %p" % [ Gem.default_path, Bundler.bundle_path ]
          warn "result: %p" % result
          if result && Gem.default_path.include?(Bundler.bundle_path)
            warn "REHASHING from bundler"
            system "rbenv", "rehash"
          end
        rescue
          warn "rbenv: error in bundle post-install hook (#{$!})"
        end
        result
      end
    end
  end
else
  warn "normal hook"
  begin
    Gem.post_install(&hook)
    Gem.post_uninstall(&hook)
  rescue
    warn "rbenv: error installing gem-rehash hooks (#{$!})"
  end
end
