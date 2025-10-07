# frozen_string_literal: true

require 'bundler/setup'
require 'temporalio/testing'
require 'temporalio/worker'
require 'temporalio/activity/definition'
require 'temporalio/workflow/definition'

Dir['spec/support/**/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.profile_examples = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
