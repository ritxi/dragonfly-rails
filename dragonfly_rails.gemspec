# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dragonfly_rails/version"

Gem::Specification.new do |s|
  s.name        = "dragonfly-rails"
  s.version     = DragonflyRails::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ricard Forniol"]
  s.email       = ["ricard@kaltha.com"]
  s.homepage    = ""
  s.summary     = %q{Add model scope to your Dragonfly models}
  s.description = %q{Dragonfly uses current datetime to store files, instead use :id_partition like paperclip and add model scope to separte diferent model images}

  s.rubyforge_project = "dragonfly_rails"
  
  s.add_dependency('dragonfly')
  s.add_dependency('rails')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('rack-cache')
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

