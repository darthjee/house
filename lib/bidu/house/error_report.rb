class Bidu::House::ErrorReport
  attr_reader :period, :threshold, :scope, :clazz

  def initialize(period, threshold, scope, clazz)
    @period =  period
    @threshold = threshold
    @scope = scope
    @clazz = clazz
  end

  def status
    @status ||= (percentage > threshold) ? :error : :ok
  end

  def percentage
    @percentage ||= last_entires.percentage(scope)
  end

  def scoped
    @scoped ||= last_entires.public_send(scope)
  end

  private

  def last_entires
    @last_entires ||= clazz.where('updated_at >= ?', period.seconds.ago)
  end
end
