module MondidoSDK
  class MondidoModel
    def update_from_response(attributes)
      attributes.each do |attribute, value|
        attribute_symbol = "@#{attribute}".to_sym          
        setter_symbol = "#{attribute}=".to_sym
        instance_variable_set attribute_symbol, value if respond_to?(setter_symbol)
      end
    end
  end
end
