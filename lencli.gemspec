# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lencli/version/version'

Gem::Specification.new do |spec|
  spec.name          = "lencli"
  spec.version       = LenCLI::VERSION
  spec.authors       = ["kph2u2"]
  spec.email         = ["kph2u2@gmail.com"]

  spec.summary       = %q{A command line app for Lendesk}
  spec.homepage      = "https://www.lendesk.com"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "thor", "~> 0.20.0"
  spec.add_development_dependency "mini_magick", "~> 4.8.0"
  spec.add_development_dependency "byebug"
end
