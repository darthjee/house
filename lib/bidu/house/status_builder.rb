class Bidu::House::StatusBuilder
  def build(key, parameters = {})
    Bidu::House::Status.new(reports_for(key, parameters))
  end

  def add_report_config(key, config)
    status_key = config.delete(:on) || :default
    report_builder.add_config(key, config)
    config_for(status_key) << key
  end

  private

  def report_builder
    @report_builder ||= Bidu::House::ReportBuilder.new
  end

  def reports_for(key, parameters)
    config_for(key).map do |report_key|
      report_builder.build(report_key, parameters)
    end
  end

  def configs
    @configs ||= {}
  end

  def config_for(key)
    configs[key] ||= []
  end
end
