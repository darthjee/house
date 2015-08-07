module Bidu
  module House
    class ReportBuilder
      def build(key, parameters = {})
        params = parameters.slice(:period, :threshold)
        config = configs[key].merge(params)
        report_class(:error).new(config)
      end

      def add_config(key, config)
        configs[key] = config
      end

      private

      def report_class(type)
        Bidu::House::Report.const_get(type.to_s.camelize)
      end

      def configs
        @configs ||= {}
      end
    end
  end
end
