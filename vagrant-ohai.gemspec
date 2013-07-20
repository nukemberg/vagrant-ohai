# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-ohai/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-ohai"
  spec.version       = VagrantPlugins::Ohai::VERSION
  spec.authors       = ["Avishai Ish-Shalom"]
  spec.email         = ["avishai@fewbytes.com"]
  spec.description   = %q{Vagrant plugin which installs an Ohai plugn to properly detect private ipaddress}
  spec.summary       = %q{Vagrant plugin which installs an Ohai plugn to properly detect private ipaddress}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
