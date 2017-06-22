module Mercy
  class Report
    class Dummy < Report
      ALLOWED_PARAMETERS=[:period, :threshold]
      def initialize(options)
      end
    end
  end
end

class Dummy
  ALLOWED_PARAMETERS=[:period, :threshold]
  def initialize(options)
  end
end
