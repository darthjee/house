# frozen_string_literal: true

require 'simplecov'

SimpleCov.profiles.define 'gem' do
  add_filter '/spec/'
end

SimpleCov.start 'gem'

require 'pry-nav'
require 'mercy'

require 'active_record'
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', database: ':memory:'
)

require File.expand_path('spec/dummy/config/environment')
require File.expand_path('spec/dummy/db/schema.rb')
require 'rspec/rails'
require 'active_support/railtie'

support_files = File.expand_path('spec/support/**/*.rb')
Dir[support_files].sort.each { |file| require file }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.filter_run_excluding :integration unless ENV['ALL']

  config.order = 'random'
end
