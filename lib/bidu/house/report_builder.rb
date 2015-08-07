module Bidu
  module House
    class ReportBuilder
      def build(key, parameters = {})
        config = config_for(key)
        type = config[:type] || :error
        params = slice_parameters_for(key, parameters)
        report_class(key).new(config.merge(params))
      end

      def add_config(key, config)
        configs[key] = Bidu::House::Config.new(config)
      end

      private

      def slice_parameters_for(key, parameters)
        parameters.slice(*allowed_parameters_keys_for(key))
      end

      def allowed_parameters_keys_for(key)
        config_for(key).report_class::ALLOWED_PARAMETERS
      end

      def config_for(key)
        configs[key]
      end

      def report_class(key)
        config_for(key).report_class
      end

      def configs
        @configs ||= {}
      end
    end
  end
end
