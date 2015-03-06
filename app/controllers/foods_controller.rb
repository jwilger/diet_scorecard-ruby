class FoodsController < ApplicationController
  service(:meals) { Meal.for_user_id(current_user.id) }

  template_attr :food

  def new
    self.food = meal.new_food
  end

  private

  def meal
    meals.find(params.require(:meal_id))
  end
end
