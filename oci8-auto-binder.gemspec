# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oci8-auto-binder/version'

Gem::Specification.new do |spec|
  spec.name          = "oci8-auto-binder"
  spec.version       = OCI8AutoBinder::VERSION
  spec.authors       = ["Junichiro Kasuya"]
  spec.email         = ["junichiro.kasuya@gmail.com"]

  spec.summary       = %q{execute parameternized query for OCI8}
  spec.description   = %q{This library changes the query to parameterized query automatically.}
  spec.homepage      = "https://github.com/jksy/oci8-auto-binder"
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.3.0'
  spec.add_runtime_dependency "oracle-sql-parser", "~> 1.0.0"
  spec.add_runtime_dependency "ruby-oci8", "~> 2.2.8"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "test-unit", "~> 3.1"
end
