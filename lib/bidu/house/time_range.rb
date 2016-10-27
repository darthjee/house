module Bidu::House
  class TimeRange
    include JsonParser

    attr_reader :json
    json_parse :from, :to, after: :parse_time

    def initialize(options = {})
      @json = options
    end

    def include?(time)
      from <= time && to >= time
    end

    private

    def parse_time(time)
      (hour, minute) = time.split(':').map(&:to_i)
      At.new(
        hour: hour,
        minute: minute
      )
    end
  end
end
