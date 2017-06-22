module Mercy
  class Status
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
      }.merge(reports_jsons)
    end

    private

    def reports_jsons
      reports.map(&:as_json).as_hash(reports.map(&:id))
    end
  end
end
