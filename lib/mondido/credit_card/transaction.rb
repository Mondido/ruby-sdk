module Mondido
  module CreditCard
    class Transaction < BaseModel
      include ActiveModel::Model
      include Mondido::BaseBehaviour

      attr_accessor :id,
                    :amount,
                    :currency,
                    :card_number,
                    :card_holder,
                    :card_cvv,
                    :card_expiry,
                    :card_type,
                    :payment_ref,
                    :customer_ref,
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


      def self.delete(id)
        raise Mondido::Exceptions::NotApplicable.new 'Can not delete Transaction'
      end

      def self.create(attributes={})
        metadata = attributes[:metadata]        
        metadata = metadata.to_json if metadata && metadata.respond_to?(:to_json)
        attributes[:metadata] = metadata
        super(attributes)
      end

      def initialize(attributes={})
        super
      end

      def set_hash!
        unhashed = [Mondido::Credentials.merchant_id, payment_ref, customer_ref, amount, currency, Mondido::Credentials.secret].map(&:to_s)
        self.hash = Digest::MD5.hexdigest(unhashed.join)
      end

    end
  end
end
