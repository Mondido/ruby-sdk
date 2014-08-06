require 'bundler/setup'

Bundler.setup

require 'rails'
require 'mondido'
require 'webmock/rspec'

RSpec.configure do |config|
end

# Monkeymock the config class
module Mondido
  class Credentials
    MERCHANT_ID = 1
    SECRET = 'secret'
    PASSWORD = 'password'
  end
end
