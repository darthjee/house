module Bidu
  module House
    class Report
      include JsonParser
      require 'bidu/house/report/active_record'
      require 'bidu/house/report/error'
      require 'bidu/house/report/range'
      ALLOWED_PARAMETERS = []
      DEFAULT_OPTION = {}

      attr_reader :json

      json_parse :id, case: :snake

      def initialize(options)
        @json = DEFAULT_OPTION.merge(options)
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
    end
  end
end
