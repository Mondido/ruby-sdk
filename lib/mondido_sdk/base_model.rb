module MondidoSDK
  class BaseModel
    def update_from_response(attributes)
      attributes.each do |attribute, value|
        attribute_symbol = "@#{attribute}".to_sym          
        setter_symbol = "#{attribute}=".to_sym
        instance_variable_set attribute_symbol, value if respond_to?(setter_symbol)
      end
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
  end
end
