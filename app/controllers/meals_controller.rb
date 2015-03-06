class MealsController < ApplicationController
  service(:meals) { Meal.for_user_id(current_user.id) }

  template_attr :meal
  template_attr :daily_scorecard_path_params

  def new
    meal_time = Date.new(params[:year].to_i, params[:month].to_i,
                         params[:day].to_i).beginning_of_day
    self.meal = meals.new(consumed_at: meal_time)
    self.daily_scorecard_path_params = date_params_from(meal_time)
    render
  end

  def create
    self.meal = meals.create(meal_params)
    if meal.valid?
      redirect_to daily_scorecard_path(date_params_from(meal.consumed_at))
    else
      self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
      render action: 'new', status: 422
    end
  end

  def destroy
    self.meal = meals.destroy(params[:id])
    flash[:notice] = [{key: '.meal_deleted', meal_name: meal.name}]
    redirect_to daily_scorecard_path(date_params_from(meal.consumed_at))
  end

  def edit
    self.meal = meals.find(params[:id])
    self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
  end

  def update
    self.meal = meals.find(params[:id])
    meal.update_attributes(meal_params)
    if meal.valid?
      redirect_to daily_scorecard_path(date_params_from(meal.consumed_at))
    else
      self.daily_scorecard_path_params = date_params_from(meal.consumed_at)
      render action: 'edit', status: 422
    end
  end

  private

  def meal_params
    params.require(:meal).permit(:consumed_at, :name)
  end
end
