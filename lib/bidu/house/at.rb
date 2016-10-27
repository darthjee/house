class Bidu::House::At
  include ActiveModel::Model
  attr_accessor :year, :month, :day, :week_day, :hour, :minute, :second

  def >(target)
    true
  end

  def <(target)
    time(target) < target
  end

  def >=(target)
    self == target || self > (target)
  end

  def <=(target)
    self == target || self < (target)
  end

  def ==(target)
    true
  end

  private

  def time(target)
    Time.new(
      year || target.year,
      month || target.month,
      day || target.day,
      hour || target.hour,
      minute || target.min,
      second || target.sec
    )
  end
end

