module Mondido
  class BaseModel
    def update_from_response(attributes)
      attributes.each do |attribute, value|
        attribute_symbol = "@#{attribute}".to_sym          
        setter_symbol = "#{attribute}=".to_sym
        instance_variable_set attribute_symbol, value if respond_to?(setter_symbol)
      end

      return self
    end

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


    def self.create(attributes)
      object = self.new(attributes)
      object.valid? # Will raise exception if validation fails

      object.set_hash! if object.respond_to? :set_hash!

      response = Mondido::RestClient.process(object)

      object.update_from_response(JSON.parse(response.body))
    end


    def self.get(id)
      response = Mondido::RestClient.get(pluralized, id)
      object = self.new
      object.update_from_response(JSON.parse(response.body))
    end

    private

    def self.pluralized
      self.name.split('::').last.underscore.pluralize
    end

  end
end
