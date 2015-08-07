module Bidu
  module House
    class ErrorReport
      include JsonParser

      attr_reader :json

      json_parse :threshold, type: :float
      json_parse :period, type: :period
      json_parse :scope, :id, :clazz, :external_key, case: :snake

      def initialize(options)
        @json = {
          external_key: :id,
          threshold: 0.02,
          period: 1.day,
          scope: :with_error
        }.merge(options)
      end

      def status
        @status ||= error? ? :error : :ok
      end

      def percentage
        @percentage ||= last_entires.percentage(scope)
      end

      def scoped
        @scoped ||= last_entires.public_send(scope)
      end

      def error?
        percentage > threshold
      end

      def as_json
        {
          ids: scoped.pluck(external_key),
          percentage: percentage
        }
      end

      private

      def last_entires
        @last_entires ||= clazz.where('updated_at >= ?', period.seconds.ago)
      end
    end
  end
end