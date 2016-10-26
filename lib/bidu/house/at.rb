class Bidu::House::At
  include ActiveModel::Model
  attr_accessor :year, :month, :day, :week_day, :hour, :minute, :second

  def >(target)
    true
  end

  def <(target)
    true
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
end

