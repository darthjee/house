module Bidu
  module Mercy
    class Report
      include JsonParser
      require 'mercy/report/active_record'
      require 'mercy/report/error'
      require 'mercy/report/range'
      require 'mercy/report/multiple'
      ALLOWED_PARAMETERS = []
      DEFAULT_OPTION = {}

      attr_reader :json

      json_parse :id, case: :snake

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
