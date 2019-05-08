# frozen_string_literal: true

module Mercy
  class PeriodParser
    class << self
      def parse(period)
        return unless period
        return period if period.is_a?(Integer)
        new(period).to_seconds
      end
    end

    def initialize(period)
      @period = period
    end

    def to_seconds
      return unless period =~ /^\d+(years|months|days|hours|minutes|seconds)?/
      type.blank? ? value.seconds : value.public_send(type)
    end

    private

    attr_reader :period

    def value
      @period_value ||= period.gsub(/\D+/, '').to_i
    end

    def type
      @period_type ||= period.gsub(/\d+/, '')
    end
  end
end
