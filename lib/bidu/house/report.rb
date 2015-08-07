module Bidu
  module House
    module Report

      require 'bidu/house/report/error'

      def self.build(type, config)
        const_get(type.to_s.camelize).new(config)
      end
    end
  end
end
