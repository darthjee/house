module Bidu
  module Mercy
    class ReportBuilder
      def build(key, parameters = {})
        config = config_for(key)
        config.build(parameters)
      end

      def add_config(key, config)
        configs[key] = Mercy::ReportConfig.new(config)
      end

      private

      def config_for(key)
        configs[key]
      end

      def configs
        @configs ||= {}
      end
    end
  end
end
