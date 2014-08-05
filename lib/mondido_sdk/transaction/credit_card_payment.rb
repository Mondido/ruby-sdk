
module MondidoSDK
  module Transaction
    class CreditCardPayment < MondidoModel
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
                    :payment_details

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



      def self.create(attributes)
        transaction = MondidoSDK::Transaction::CreditCardPayment.new(attributes)
        return transaction unless transaction.valid?

        unhashed = [@@merchant_id, attributes[:payment_ref], attributes[:amount], attributes[:currency], @@secret]
        attributes['hash'] = Digest::MD5.hexdigest(unhashed.join)
        uri = URI.parse 'http://api.localmondido.com:3000/v1/transactions?extend=payment_details'
        http = Net::HTTP.new(uri.host, uri.port)
        # http.use_ssl = true
        request = Net::HTTP::Post.new(uri.path)
        request.basic_auth(@@merchant_id, @@password)
        request.set_form_data(attributes)
        response = http.start { |http| http.request(request) }

        if (200..299).include?(response.code.to_i)
          transaction.update_from_response(JSON.parse(response.body))
        else
          transaction.errors.add(:response, 'errorous')
        end
        return transaction
      end
    end
  end
end
