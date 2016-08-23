module Bidu
  module House
    class Report
      ALLOWED_PARAMETERS = []
      DEFAULT_OPTION = {}

      def initialize(options)
        @json = self.class::DEFAULT_OPTION.merge(options)
      end

      require 'bidu/house/report/error'
    end
  end
end
