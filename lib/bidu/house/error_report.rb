class Bidu::House::ErrorReport
  include ConcernBuilder::OptionsParser

  delegate :period, :threshold, :scope, :clazz, :external_key, to: :options_object

  def initialize(options)
    @options = {
      external_key: :id
    }.merge(options)
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

  def as_json
    {
      documents: scoped.map(&external_key),
      percentage: percentage
    }
  end

  private

  def last_entires
    @last_entires ||= clazz.where('updated_at >= ?', period.seconds.ago)
  end
end
