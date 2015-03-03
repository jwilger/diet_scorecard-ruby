class MealsController < ApplicationController
  service(:meals) { Meal }

  template_attr :meal

  def new
    self.meal = meals.new(date: Date.new(params[:year].to_i, params[:month].to_i,
                                         params[:day].to_i))
    render
  end
end
