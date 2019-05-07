# frozen_string_literal: true

module Mercy
  class Report
    class Range < Report::ActiveRecord
      ALLOWED_PARAMETERS = %i[period maximum minimum].freeze
      DEFAULT_OPTION = {
        period: 1.day,
        scope: :all
      }.freeze

      expose :scope
      expose :maximum, type: :infinity_float, default: 'inf'
      expose :minimum, type: :infinity_float, default: '-inf'

      def initialize(options)
        super(DEFAULT_OPTION.merge(options))
      end

      def scoped
        @scoped ||= fetch_scoped(last_entries, scope)
      end

      def error?
        @error ||= !count_in_range?
      end

      def as_json
        {
          status: status,
          count: count
        }
      end

      def count
        scoped.count
      end

      private

      def range
        (minimum..maximum)
      end

      def count_in_range?
        range.include?(count)
      end
    end
  end
end
