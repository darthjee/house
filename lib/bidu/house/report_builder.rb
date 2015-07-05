class Bidu::House::ReportBuilder
  def build(key)
    Bidu::House::ErrorReport.new(configs[key])
  end

  def add_config(key, config)
    configs[key] = config
  end

  private

  def configs
    @configs ||= {}
  end
end
