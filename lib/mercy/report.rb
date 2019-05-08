# frozen_string_literal: true

module Mercy
  class Report
    include Arstotzka
    require 'mercy/report/active_record'
    require 'mercy/report/error'
    require 'mercy/report/range'
    require 'mercy/report/multiple'
    ALLOWED_PARAMETERS = [].freeze
    DEFAULT_OPTION = {}.freeze

    def self.default_options
      return {} if self == Report
      superclass.default_options.merge(self::DEFAULT_OPTION)
    end

    attr_reader :json

    expose :id, case: :snake

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
  end
end
