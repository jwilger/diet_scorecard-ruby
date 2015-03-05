class FoodsController < ApplicationController
  service(:meals) { Meal.for_user_id(current_user.id) }

  template_attr :meal
  template_attr :food
  template_attr :daily_scorecard_path_params

  def new
    self.meal = meals.find(params[:meal_id])
    self.food = meal.foods.build
    self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
  end

  def create
    self.meal = meals.find(meal_params[:meal_id])
    self.food = meal.foods.create(food_params)
    self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
    if food.valid?
      redirect_to daily_scorecard_path(daily_scorecard_path_params)
    else
      render action: :new
    end
  end

  def destroy
    self.food = Food.destroy(params[:id])
    redirect_to daily_scorecard_path(date_params_from(food.meal.consumed_at))
  end

  private

  def meal_params
    params.require(:food).permit(:meal_id)
  end

  def food_params
    params.require(:food).permit(:name, *Food.servings_fields)
  end
end
