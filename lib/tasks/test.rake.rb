require 'rake'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the restful_authentication plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << %w(lib test/test_helper)
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end