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



    def initialize(attributes)
      super(attributes)
      return unless valid?

      unhashed = [Mondido::Config::MERCHANT_ID, payment_ref, amount, currency, Mondido::Config::SECRET]
      self.hash = Digest::MD5.hexdigest(unhashed.join)

      response = Mondido::RestClient.process(self)


      if (200..299).include?(response.code.to_i)
        update_from_response(JSON.parse(response.body))
      else
        errors.add(:response, 'errorous')
      end
    end

    def success?
      status == 'approved'
    end

  end
end
