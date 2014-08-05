module MondidoSDK
  module CreditCard
    class Transaction < BaseModel
      include MondidoSDK::Config
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
                presence: { message: 'errors.currency.missing' }

      validates :amount,
                presence: { message: 'errors.amount.missing' }

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

        unhashed = [MondidoSDK::Config::MERCHANT_ID, payment_ref, amount, currency, MondidoSDK::Config::SECRET]
        self.hash = Digest::MD5.hexdigest(unhashed.join)

        response = MondidoSDK::RestClient.process(self)


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
end
