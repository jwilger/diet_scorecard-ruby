class FoodsController < ApplicationController
  service(:meals) { Meal.for_user_id(current_user.id) }

  template_attr :food
  template_attr :daily_scorecard_path_params

  def new
    self.food = meal.new_food
    self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
  end

  private

  def meal
    @meal ||= meals.find(params.require(:meal_id))
  end
end
