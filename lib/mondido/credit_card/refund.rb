module Mondido
  module CreditCard
    class Refund < BaseModel
      include ActiveModel::Model

      attr_accessor :id,
                    :amount,
                    :reason,
                    :ref,
                    :created_at,
                    :transaction,
                    :transaction_id

      validates :transaction_id,
                presence: { message: 'errors.transaction_id.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :amount,
                presence: { message: 'errors.amount.missing' },
                strict: Mondido::Exceptions::ValidationException

      validates :reason,
                presence: { message: 'errors.reason.missing' },
                strict: Mondido::Exceptions::ValidationException

      def initialize(attributes={})
        super
      end

      def self.create(attributes)
        refund = Mondido::CreditCard::Refund.new(attributes)
        refund.valid? # Will raise exception if validation fails

        response = Mondido::RestClient.process(refund)

        refund.update_from_response(JSON.parse(response.body))
      end

      def self.get(id)
        response = Mondido::RestClient.get(:refunds, id)
        refund = Mondido::CreditCard::Refund.new
        refund.update_from_response(JSON.parse(response.body))
      end
    end
  end
end
