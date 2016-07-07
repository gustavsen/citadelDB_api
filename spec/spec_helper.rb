require 'rack/test'
require 'rspec'
require 'pp'

ENV['RACK_ENV'] ||= 'test'

require_relative '../citadel_app.rb'

RSpec.configure do |c|
  c.around(:each) do |example|
    ActiveRecord::Base.connection.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

module WithRollback
  def temporarily(&block)
    ActiveRecord::Base.connection.transaction do
      block.call
      raise ActiveRecord::Rollback
    end
  end
end
