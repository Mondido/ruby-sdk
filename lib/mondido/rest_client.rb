module Mondido
  class RestClient

    # @param instance [Mondido::*]
    # @return [Mondido::*]
    # Takes an instance of a Mondido object and calls the API to process the transaction
    def self.process(instance)
      uri_string = [Mondido::Config::URI, instance.class.pluralized].join('/')
      call_api(uri: uri_string, data: instance.api_params, http_method: :post)
    end

    private

    def self.call_api(args)
      require 'net/https'
      uri = URI.parse args[:uri]
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http_method = args[:http_method] || :get
      case http_method
        when :post
          request = Net::HTTP::Post.new(uri.path)
        when :get
          if args.has_key?(:query)
            query = "?#{args[:query]}"
          else
            query = ''
          end
          request = Net::HTTP::Get.new(uri.path + query)
      end

      request.basic_auth(Mondido::Credentials.merchant_id, Mondido::Credentials.password)
      request.set_form_data(args[:data]) if args.has_key?(:data)
      response = http.start { |http| http.request(request) }

      unless (200..299).include?(response.code.to_i)
        error_name = JSON.parse(response.body)['name'] rescue nil || 'errors.generic'
        raise Mondido::Exceptions::ApiException.new(error_name)
      end

      return response
    end

    def self.get(method, id=nil)
      uri_string = [Mondido::Config::URI, method.to_s, id.to_s].join('/')
      call_api(uri: uri_string)
    end

    def self.all(method, filter={})
      uri_string = [Mondido::Config::URI, method.to_s].join('/')
      call_api(uri: uri_string, query: filter.to_query)
    end

  end
end
