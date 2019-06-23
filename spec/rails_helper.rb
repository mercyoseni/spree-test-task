require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'factory_bot'
require 'faker'

# Requires spree test helpers
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/controller_requests'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  FactoryBot.definition_file_paths = [File.expand_path('../factories', __FILE__)]
  FactoryBot.find_definitions
  config.include FactoryBot::Syntax::Methods
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :controller
end
