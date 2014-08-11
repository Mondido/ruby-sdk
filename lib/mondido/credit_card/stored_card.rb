module Mondido
  module CreditCard
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
                    :hash,
                    :token

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

    end
  end
end
