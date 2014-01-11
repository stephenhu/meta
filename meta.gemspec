# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta/version'

Gem::Specification.new do |spec|
  spec.name          = "meta"
  spec.version       = Meta::VERSION
  spec.authors       = ["stephenhu"]
  spec.email         = ["epynonymous@outlook.com"]
  spec.description   = %q{opinionated static web page generator}
  spec.summary       = %q{opinionated static web page generator}
  spec.homepage      = "http://github.io/stephenhu/meta"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.bindir        = "bin"

  spec.add_dependency "colorize", "~>0.6.0"
  spec.add_dependency "haml", "~>4.0.4"
  spec.add_dependency "highline", "~>1.6.20"
  spec.add_dependency "rack", "~>1.5.2"
  spec.add_dependency "redcarpet", "~>3.0.0"
  spec.add_dependency "sequel", "~>4.5.0"
  spec.add_dependency "sqlite3", "~>1.3.8"
  spec.add_dependency "thin", "~>1.6.1"
  spec.add_dependency "thor", "~>0.18.1"
  spec.add_dependency "tilt", "~>2.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

end

