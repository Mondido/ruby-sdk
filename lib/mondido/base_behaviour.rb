module Mondido
  module BaseBehaviour
    def initialize(attributes={})
      setters = self.methods
        .select{ |method| !method.to_s.match(/=\z/).nil? && method.match(/\A(!|=|_)/).nil? }
        .map{ |method| method.to_s[0, method.length-1].to_sym }

      attributes.select!{ |k,v|
        setters.include?(k)
      }

      super(attributes)
    end
  end
end
