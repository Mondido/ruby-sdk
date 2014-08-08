module Mondido
  class Webhook
    def self.receive(request)
      json = request.body.string
      hash = JSON.parse(json)
      transaction = Mondido::CreditCard::Transaction.new(hash)
    end
  end
end
