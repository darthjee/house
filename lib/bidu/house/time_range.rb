module Bidu::House
  class TimeRange
    include JsonParser

    attr_reader :json
    json_parse :from, :to, after: :parse_time

    def initialize(options = {})
      @json = options
    end

    def include?(time)
      f = from.time(time)
      t = to.time(time)

      return f <= time || t >= time if f > t
      f <= time && t >= time
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
