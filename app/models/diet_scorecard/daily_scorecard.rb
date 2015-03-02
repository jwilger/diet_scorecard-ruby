module DietScorecard
  class DailyScorecard
    attr_accessor :date
    private :date=

    def initialize(date:)
      self.date = date.to_date
    end

    def total_points
      0
    end

    def food_type_scorecards
      []
    end

    def previous
      self.class.new(date: date - 1)
    end

    def next
      self.class.new(date: date + 1)
    end

    def to_param
      {:year => date.year.to_s, :month => date.month.to_s, :day => date.day.to_s}
    end
  end
end
