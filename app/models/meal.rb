class Meal < ActiveRecord::Base
  class << self
    def for_date(date)
      where('consumed_at >= ? AND consumed_at <= ?',
            date.beginning_of_day, date.end_of_day)
    end

    def for_user_id(user_id)
      where(user_id: user_id)
    end
  end

  validates :name, presence: true
  validates :consumed_at, presence: true

  has_many :foods, dependent: :destroy
end
