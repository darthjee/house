module Bidu
  module House
    class Report
      include JsonParser
      require 'bidu/house/report/active_record'
      require 'bidu/house/report/error'
      require 'bidu/house/report/range'
      require 'bidu/house/report/multiple'
      ALLOWED_PARAMETERS = []
      DEFAULT_OPTION = {}

      attr_reader :json

      json_parse :id, case: :snake
      json_parse :active, class: TimeRange

      def initialize(options = {})
        @json = default_option.merge(options)
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

      def enabled?
        active.nil? || active.include?(Time.now)
      end

      private

      def default_option
        self.class.default_options
      end

      def self.default_options
        return {} if self == Report
        self.superclass.default_options.merge(self::DEFAULT_OPTION)
      end
    end
  end
end
