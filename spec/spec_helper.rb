require 'coveralls'

require 'rspec'
require 'rack/test'

Coveralls.wear!
# load code after this line
require File.join(File.dirname(__FILE__), '..', 'app', 'app.rb')
require File.join(File.dirname(__FILE__), '..', 'app', 'middleware', 'camel_snake_exchanger.rb')

RSpec.configure do |config|
  ENV['RACK_ENV'] ||= 'test'
end
