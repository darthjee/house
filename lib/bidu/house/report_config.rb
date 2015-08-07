module Bidu
  module House
    class ReportConfig
      attr_accessor :config

      delegate :[], :[]=, :merge, to: :config

      def initialize(config)
        @config = config
      end

      def build(parameters)
        params = slice_parameters(parameters)
        report_class.new(config.merge(params))
      end

      def type
        self[:type] ||= :error
      end

      def report_class
        @report_class ||= Bidu::House::Report.const_get(type.to_s.camelize)
      end

      def slice_parameters(parameters)
        parameters.slice(*allowed_parameters)
      end

      def allowed_parameters
        report_class::ALLOWED_PARAMETERS
      end
    end
  end
end