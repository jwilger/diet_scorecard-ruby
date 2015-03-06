require 'diet_scorecard/meal_scorecard'

module DietScorecard
  class FoodTypeScoreCard
    attr_accessor :food_type, :date
    private :food_type=, :date=

    def initialize(food_type:, date:, meals_service:,
                   meal_scorecards_service: MealScorecard)
      self.food_type = food_type
      self.date = date
      self.meals_service = meals_service
      self.meal_scorecards_service = meal_scorecards_service
    end

    def food_type_key
      food_type.key
    end

    def servings_consumed
      meals.reduce(0) { |total, meal|
        total + meal.total_servings(food_type_key)
      }
    end

    def servings_recommended
      food_type.recommended_servings
    end

    def points_earned
      return 0 if servings_consumed < 1
      (1..servings_consumed).reduce(0) { |total, serving|
        total + food_type.points_for_serving(serving)
      }
    end

    def possible_points
      food_type.possible_points
    end

    private

    attr_accessor :meals_service, :meal_scorecards_service

    def meals
      meal_scorecards_service.for_date(date, meals_service: meals_service)
    end
  end
end
