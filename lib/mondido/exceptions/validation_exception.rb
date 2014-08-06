module Mondido
  module Exceptions
    class ValidationException < StandardError
      def initialize(err)
        match = err.match(/.+\s(.+)/)
        error = match[1]
        super(error)
      end
    end
  end
end
