class DailyScorecardsController < ApplicationController
  helper :food_type

  service(:clock) { Time.zone }

  service(:daily_scorecards) {
    require 'diet_scorecard/daily_scorecard'
    DietScorecard::DailyScorecard
  }

  service(:meals) { Meal }

  template_attr :daily_scorecard

  def today
    render_daily_scorecard clock.now
  end

  def show
    render_daily_scorecard clock.local(params[:year], params[:month], params[:day])
  end

  private

  def render_daily_scorecard(date)
    self.daily_scorecard = daily_scorecards.new(
      date: date,
      meals_service: meals.for_user_id(current_user.id)
    )
    render action: :show
  end
end
