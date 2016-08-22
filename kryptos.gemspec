# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kryptos/version'

Gem::Specification.new do |gem|
  gem.name          = "kryptos"
  gem.version       = Kryptos::VERSION
  gem.authors       = ["wlipa"]
  gem.email         = ["dojo@masterleep.com"]
  gem.description   = %q{Supports keeping your secrets.yml in source control, but encrypted using a key from the file system.}
  gem.summary       = %q{Encrypt app secrets in source control using a file based key that is not version controlled}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'gibberish'
end
