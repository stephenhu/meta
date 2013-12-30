# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meta/version'

Gem::Specification.new do |spec|
  spec.name          = "meta"
  spec.version       = Meta::VERSION
  spec.authors       = ["stephenhu"]
  spec.email         = ["epynonymous@outlook.com"]
  spec.description   = %q{meta language compiler for static web pages }
  spec.summary       = %q{meta compiler (meta)}
  spec.homepage      = "http://github.io/stephenhu/meta"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.bindir        = "bin"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

