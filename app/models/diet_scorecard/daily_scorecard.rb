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
  end
end
