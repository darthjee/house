class Bidu::House::Status
  attr_reader :reports

  def initialize(reports)
    @reports = reports
  end

  def status
    reports.any? { |r| r.error? } ? :error : :ok
  end

  def as_json
    {
      status: status
    }
  end
end
