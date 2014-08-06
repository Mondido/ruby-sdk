module Mondido
  class StoredCard < BaseModel
    include ActiveModel::Model

    attr_accessor :id,
                  :currency,
                  :card_number,
                  :card_holder,
                  :card_cvv,
                  :card_expiry,
                  :card_type,
                  :metadata,
                  :created_at,
                  :merchant_id,
                  :test,
                  :status,
                  :customer,
                  :hash

    validates :currency,
              presence: { message: 'errors.currency.missing' }

    validates :card_number,
              presence: { message: 'errors.card_number.missing' }

    validates :card_cvv,
              presence: { message: 'errors.card_cvv.missing' }

    validates :card_expiry,
              presence: { message: 'errors.card_expiry.missing' }

    validates :card_type,
              presence: { message: 'errors.card_type.missing' }



    def initialize(attributes={})
      super(attributes)
    end

    def self.create(attributes)
      stored_card = Mondido::StoredCard.new(attributes)
      stored_card.valid? # Will raise exception if validation fails

      #unhashed = [Mondido::Credentials::MERCHANT_ID, stored_card.payment_ref, stored_card.amount, stored_card.currency, Mondido::Credentials::SECRET]
      #stored_card.hash = Digest::MD5.hexdigest(unhashed.join)

      response = Mondido::RestClient.process(stored_card)


      stored_card.update_from_response(JSON.parse(response.body))
    end

    def self.get(id)
      response = Mondido::RestClient.get(:stored_cards, id)
      stored_card = Mondido::StoredCard.new
      stored_card.update_from_response(JSON.parse(response.body))
    end

  end
end
