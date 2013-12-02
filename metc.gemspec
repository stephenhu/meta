# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metc/version'

Gem::Specification.new do |spec|
  spec.name          = "metc"
  spec.version       = Metc::VERSION
  spec.authors       = ["Stephen Hu"]
  spec.email         = ["hus@vmware.com"]
  spec.description   = %q{meta language compiler to static web page }
  spec.summary       = %q{meta compiiler (metc)}
  spec.homepage      = "http://github.io/stephenhu/metc"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

