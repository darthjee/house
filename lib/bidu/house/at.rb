class Bidu::House::At
  include ActiveModel::Model
  attr_accessor :year, :month, :day, :week_day, :hour, :minute, :second

  def initialize(*args)
    super(*args)
    @month = 0 if year && !month
    @day = 0 if month && !day
    @hour = 0 if day && !hour
    @minute = 0 if hour && !minute
    @second = 0 if minute && !second
  end

  def >(target)
    time(target) > target
  end

  def <(target)
    time(target) < target
  end

  def >=(target)
    !(self < target)
  end

  def <=(target)
    !(self > target)
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

