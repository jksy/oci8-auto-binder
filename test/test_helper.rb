require 'test/unit'
require 'test/unit/assertions'
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oci8-auto-binder'
