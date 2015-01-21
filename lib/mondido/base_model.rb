module Mondido
  class BaseModel

    # @param attributes [Hash]
    # @return [Mondido::*]
    # Takes the JSON response from the API and sets white listed properties for the instance
    def update_from_response(attributes)
      attributes.each do |attribute, value|
        attribute_symbol = "@#{attribute}".to_sym          
        setter_symbol = "#{attribute}=".to_sym
        instance_variable_set attribute_symbol, value if respond_to?(setter_symbol)
      end

      return self
    end

    # @return [Hash]
    # Returns a sanitized hash suitable for posting to the API
    def api_params
      excluded = %w(@errors @validation_context).map(&:to_sym)
      hash = {}
      instance_variables.reject{|o| excluded.include?(o) }.each do |var_sym|
        var_sym_without_at = var_sym.to_s[1, var_sym.length-1].to_sym
        hash[var_sym_without_at] = instance_variable_get(var_sym)
      end
      return hash
    end

    # Class Methods

    # @param attributes [Hash]
    # @return [Mondido::*]
    # Creates a transaction and posts it to the API
    def self.create(attributes)
      object = self.new(attributes)
      object.valid? # Will raise exception if validation fails

      object.set_merchant_id! if object.respond_to? :set_merchant_id!
      object.set_hash! if object.respond_to? :set_hash!

      response = Mondido::RestClient.process(object)

      object.update_from_response(JSON.parse(response.body))
    end

    # @param id [Integer]
    # @return [Mondido::*]
    # Retrieves an object from the API, by ID
    def self.get(id)
      response = Mondido::RestClient.get(pluralized, id)
      object = self.new
      object.update_from_response(JSON.parse(response.body))
    end

    # @param filter [Hash] :limit, :offset
    # @return [Array]
    # Retrieves a list of objects from the API
    def self.all(filter={})
      response = Mondido::RestClient.all(pluralized, filter)
      JSON.parse(response.body).map do |attributes|
        object = self.new
        object.update_from_response(attributes)
      end
    end

    # @param id [Integer]
    # @return [Mondido::*]
    def self.delete(id)
      response = Mondido::RestClient.delete(pluralized, id)
      object = self.new
      object.update_from_response(JSON.parse(response.body))
    end

    private

    # @return [String]
    # Returns a camel cased pluralized version of the class name
    # e.g. converts Mondido::CreditCard::StoredCard to 'stored_cards'
    def self.pluralized
      self.name.split('::').last.underscore.pluralize
    end

  end
end
