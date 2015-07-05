class Bidu::House::ReportBuilder
  def build(key, parameters)
    Bidu::House::ErrorReport.new(configs[key].merge(parameters))
  end

  def add_config(key, config)
    configs[key] = config
  end

  private

  def configs
    @configs ||= {}
  end
end
