module Bidu
  module House
    class Report
      require 'bidu/house/report/error'

      ALLOWED_PARAMETERS = []
      DEFAULT_OPTION = {}

      attr_reader :json

      def initialize(options)
        @json = self.class::DEFAULT_OPTION.merge(options)
      end

      def status
        @status ||= error? ? :error : :ok
      end

      def error?
        raise 'Not implemented yet'
      end

      def as_json
        { status: status }
      end

      private

      def fetch_scoped(base, scope)
        if (scope.is_a?(Symbol))
          scope.to_s.split('.').inject(base) do |entries, method|
            entries.public_send(method)
          end
        else
          base.where(scope)
        end
      end

      def last_entries
        @last_entries ||= base.where('updated_at >= ?', period.seconds.ago)
      end

      def base
        fetch_scoped(clazz, base_scope)
      end
    end
  end
end
