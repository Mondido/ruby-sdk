module Mondido
  require 'active_support'
  require 'active_model'
  require 'mondido/config'
  require 'mondido/exceptions/exceptions'
  require 'mondido/rest_client'
  require 'mondido/base_model'
  require 'mondido/credit_card/transaction'
  require 'mondido/stored_card'

  class Railtie < Rails::Railtie
    initializer 'require credentials after rails is initialized' do
      require 'mondido/credentials'
    end
  end
end


