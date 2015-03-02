module DietScorecard
  class FoodType
    include Comparable

    attr_accessor :key
    private :key=

    def initialize(key, score_table:)
      self.key = key
      self.score_table = score_table.dup.tap { |st| st.freeze }
      freeze
    end

    def <=>(other)
      return key <=> other.key if mean_score == other.mean_score
      -(mean_score <=> other.mean_score)
    end

    def mean_score
      total = (1..6).to_a.reduce(0) { |total, serving|
        total + points_for_serving(serving)
      }
      total / 6.0
    end

    def points_for_serving(serving_number)
      if serving_number < 1 || serving_number % 1 != 0
        raise ArgumentError, "Serving number must be an integer greater than 0"
      end
      return score_table.last if serving_number > score_table.size
      score_table[serving_number - 1]
    end

    def minumum_servings
      score_table.each_with_index.max.last + 1
    end

    def maximum_servings
      score_table.select{ |points| points > 0 }.size
    end

    def recommended_servings
      return minumum_servings if minumum_servings == maximum_servings
      minumum_servings..maximum_servings
    end

    private

    attr_reader :score_table

    def score_table=(new_value)
      unless new_value.sort.reverse == new_value
        raise ArgumentError, "score_table must be in strictly descending order"
      end
      @score_table = new_value
    end
  end
end
