# frozen_string_literal: true

module Mercy
  # @api semipublic
  #
  # Class responsible for generating reports
  class Report
    include Arstotzka
    require 'mercy/report/active_record'
    require 'mercy/report/error'
    require 'mercy/report/range'
    require 'mercy/report/multiple'
    ALLOWED_PARAMETERS = [].freeze
    DEFAULT_OPTION = {}.freeze

    # @private
    # @api private
    #
    # default report options
    #
    # @return [Hash]
    def self.default_options
      return {} if self == Report
      superclass.default_options.merge(self::DEFAULT_OPTION)
    end

    attr_reader :json

    expose :id, case: :snake

    def initialize(options = {})
      @json = default_option.merge(options)
    end

    # Returns status string for report
    #
    # Possible outcomes are +:error+ and +:ok+
    #
    # @return [Symbol]
    def status
      @status ||= error? ? :error : :ok
    end

    # Returns if the report results in error
    #
    # @return [TrueClass,FalseClass]
    def error?
      raise 'Not implemented yet'
    end

    # Returns report hash
    #
    # @return [Hash]
    def as_json
      { status: status }
    end

    private

    # @private
    #
    # default report options
    #
    # @return [Hash]
    #
    # @see .default_options
    def default_option
      self.class.default_options
    end
  end
end
