module Bidu
  module House
    class Report
      class Range < Report
        ALLOWED_PARAMETERS=[:period, :threshold]
        DEFAULT_OPTION = {
          period: 1.day,
          scope: :all,
          minimum: nil,
          maximum: nil
        }

        json_parse :scope, :minimum, :maximum, case: :snake

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
          return range.include?(count) unless (maximum.nil? || minimum.nil?)
          return count >= minimum unless minimum.nil?
          return count <= maximum unless maximum.nil?
          true
        end
      end
    end
  end
end
