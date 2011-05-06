require 'rubygems'
require 'shoulda'

ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)

require "rails_root_s3/config/environment"
require "rails/test_help"
require File.expand_path('../lib/activerecord_test_case',__FILE__)


#Fixtures.create_fixtures(File.expand_path('../test/fixtures/schema', __FILE__), ActiveRecord::Base.connection.tables)