# frozen_string_literal: true

module Mercy
  # @api private
  #
  # Class responsible for parsing period string into period
  class PeriodParser
    class << self
      # Parses string to period
      #
      # @param period [String] period string
      #
      # @return [Integer]
      #
      # @example
      #   Mercy::PeriodParser.parse('3days')
      #
      #   # returns 3.days (259200)
      def parse(period)
        return unless period
        return period if period.is_a?(Integer)
        new(period).to_seconds
      end
    end

    def initialize(period)
      @period = period
    end

    # Parses period string to integer period
    #
    # @return [Integer]
    #
    # @example
    #   parser = Mercy::PeriodParser.new('30minutes')
    #   parser.to_period
    #   # returns 30.minutes (108000)
    def to_seconds
      return unless period =~ /^\d+(years|months|days|hours|minutes|seconds)?/
      type.blank? ? value.seconds : value.public_send(type)
    end

    private

    attr_reader :period

    # @private
    #
    # returns numeric part of period string
    #
    # @return [Integer]
    def value
      @value ||= period.gsub(/\D+/, '').to_i
    end

    # @private
    #
    # Returns the type of the period
    #
    # possible types are:
    #   - seconds
    #   - minutes
    #   - hours
    #   - days
    #   - months
    #   - years
    #
    # @return [String]
    def type
      @type ||= period.gsub(/\d+/, '')
    end
  end
end
