ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

require File.expand_path("../../rails_root/db/schema", __FILE__)

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end