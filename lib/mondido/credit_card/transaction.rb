module Mondido
  module CreditCard
    class Transaction < BaseModel
      include ActiveModel::Model

      attr_accessor :id,
                    :amount,
                    :currency,
                    :card_number,
                    :card_holder,
                    :card_cvv,
                    :card_expiry,
                    :card_type,
                    :payment_ref,
                    :metadata,
                    :items,
                    :created_at,
                    :merchant_id,
                    :vat_amount,
                    :test,
                    :status,
                    :transaction_type,
                    :cost,
                    :stored_card,
                    :customer,
                    :subscription,
                    :payment_details,
                    :hash

      validates :currency,
                presence: { message: 'errors.currency.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :amount,
                presence: { message: 'errors.amount.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :card_number,
                presence: { message: 'errors.card_number.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :card_cvv,
                presence: { message: 'errors.card_cvv.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :card_expiry,
                presence: { message: 'errors.card_expiry.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :card_type,
                presence: { message: 'errors.card_type.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :payment_ref,
                presence: { message: 'errors.payment_ref.missing' },
                strict: Mondido::Exceptions::ValidationException




      def initialize(attributes={})
        super
      end

      def self.create(attributes)
        transaction = Mondido::CreditCard::Transaction.new(attributes)
        transaction.valid? # Will raise exception if validation fails

        unhashed = [Mondido::Credentials::MERCHANT_ID, transaction.payment_ref, transaction.amount, transaction.currency, Mondido::Credentials::SECRET]
        transaction.hash = Digest::MD5.hexdigest(unhashed.join)

        response = Mondido::RestClient.process(transaction)

        transaction.update_from_response(JSON.parse(response.body))
      end

      def self.get(id)
        response = Mondido::RestClient.get(:transactions, id)
        transaction = Mondido::CreditCard::Transaction.new
        transaction.update_from_response(JSON.parse(response.body))
      end
    end
  end
end
