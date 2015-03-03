class MealsController < ApplicationController
  service(:meals) { Meal }

  template_attr :meal

  def new
    meal_time = Date.new(params[:year].to_i, params[:month].to_i,
                         params[:day].to_i).beginning_of_day
    self.meal = meals.new(consumed_at: meal_time)
    render
  end
end
