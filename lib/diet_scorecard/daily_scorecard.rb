require_relative 'food_type'
require_relative 'food_type_scorecard'

module DietScorecard
  class DailyScorecard
    attr_accessor :date
    private :date=

    def initialize(date:, meals_service:)
      self.date = date.to_date
      self.meals_service = meals_service
    end

    def total_points
      food_type_scorecards.reduce(0) { |total, fts|
        total += fts.points_earned
      }
    end

    def food_type_scorecards
      FoodType.map { |ft|
        FoodTypeScoreCard.new(food_type: ft, date: date,
                              meals_service: meals_service)
      }
    end

    def previous
      self.class.new(date: date - 1, meals_service: meals_service)
    end

    def next
      self.class.new(date: date + 1, meals_service: meals_service)
    end

    def to_param
      {:year => date.year.to_s, :month => date.month.to_s, :day => date.day.to_s}
    end

    def meals
      meals_service.for_date(date).order(:consumed_at)
    end

    private

    attr_accessor :meals_service
  end
end
