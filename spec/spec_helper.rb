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
    def self.merchant_id; 1; end
    def self.secret; 'secret'; end
    def self.password; 'password'; end
  end
end
