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

      def self.delete(id)
        raise Mondido::Exceptions::NotApplicable.new 'Can not delete Transaction'
      end
    end
  end
end
