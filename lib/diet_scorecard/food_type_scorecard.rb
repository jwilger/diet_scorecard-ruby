module DietScorecard
  class FoodTypeScoreCard
    attr_accessor :food_type, :date
    private :food_type=, :date=

    def initialize(food_type:, date:, meals_service: Meal)
      self.food_type = food_type
      self.date = date
      self.meals_service = meals_service
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

    private

    attr_accessor :meals_service

    def meals
      meals_service.for_date(date)
    end
  end
end
