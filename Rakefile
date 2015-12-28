require "bundler/gem_tasks"
require 'rake'
require 'rake/testtask'

GRAMMAR_FILES = FileList['lib/oracle-sql-parser/grammar/*.treetop']

task :build_gem => [:gen_force] do
  sh 'gem build oci8-auto-binder.gemspec'
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList[
                    'test/oci8_test.rb',
                    ]
  t.verbose = true
end
