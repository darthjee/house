class Bidu::House::ErrorReport
  include ConcernBuilder::OptionsParser

  delegate :period, :threshold, :scope, :clazz, to: :options_object

  def initialize(options)
    @options = options
  end

  def status
    @status ||= error? ? :error : :ok
  end

  def percentage
    @percentage ||= last_entires.percentage(scope)
  end

  def scoped
    @scoped ||= last_entires.public_send(scope)
  end

  def error?
    percentage > threshold
  end

  private

  def last_entires
    @last_entires ||= clazz.where('updated_at >= ?', period.seconds.ago)
  end
end
