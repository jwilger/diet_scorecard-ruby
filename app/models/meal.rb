class Meal < ActiveRecord::Base
  def self.for_date(date)
    where('consumed_at >= ? AND consumed_at <= ?',
          date.beginning_of_day, date.end_of_day)
  end
end
