module MondidoSDK
  class RestClient

    def self.process(object)
      if object.is_a? MondidoSDK::CreditCard::Transaction
        process_transaction(object)
      elsif object.is_a? MondidoSDK::StoredCard
        process_stored_card(object)
      end
    end

    private

    def self.process_transaction(object)
      call_api(:transactions, object.api_params)
    end

    def self.process_stored_card(object)
      call_api(:stored_cards, object.api_params)
    end

    def self.call_api(method, attributes=nil)
      uri = URI.parse "http://api.localmondido.com:3000/v1/#{method.to_s}"
      http = Net::HTTP.new(uri.host, uri.port)
      # http.use_ssl = true
      request = Net::HTTP::Post.new(uri.path)
      request.basic_auth(MondidoSDK::Config::MERCHANT_ID, MondidoSDK::Config::PASSWORD)
      request.set_form_data(attributes) unless attributes.nil?
      http.start { |http| http.request(request) }
    end

  end
end
