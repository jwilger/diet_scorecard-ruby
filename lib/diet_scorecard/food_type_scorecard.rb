module DietScorecard
  class FoodTypeScoreCard
    attr_accessor :food_type, :date
    private :food_type=, :date=

    def initialize(food_type:, date:)
      self.food_type = food_type
      self.date = date
    end

    def food_type_key
      food_type.key
    end

    def servings_consumed
    end

    def servings_recommended
      food_type.recommended_servings
    end

    def points_earned
    end
  end
end
