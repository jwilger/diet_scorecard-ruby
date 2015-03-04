module DietScorecard
  class MealScorecard
    def self.for_date(date, meals_service:)
      meals_service.for_date(date).map { |m| new(meal: m) }
    end

    def initialize(meal:)
      self.meal = meal
    end

    def total_servings(food_type)
      meal.foods.reduce(0) { |total, food|
        total + food.servings.fetch(food_type, 0)
      }
    end

    private

    attr_accessor :meal
  end
end
