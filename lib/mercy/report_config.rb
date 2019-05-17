# frozen_string_literal: true

module Mercy
  class ReportConfig
    attr_accessor :config

    delegate :[], :[]=, :merge, to: :config

    def initialize(config)
      @config = config
    end

    def build(parameters)
      params = slice_parameters(parameters)
      report_class.new(config.merge(params))
    end

    private

    def type
      self[:type] ||= :error
    end

    def report_class
      return type if type.is_a?(Class)
      @report_class ||= Mercy::Report.const_get(type.to_s.camelize)
    end

    def slice_parameters(parameters)
      parameters.respond_to?(:permit) ?
        parameters.permit(*allowed_parameters) :
        parameters.slice(*allowed_parameters)
    end

    def allowed_parameters
      report_class::ALLOWED_PARAMETERS
    end
  end
end
